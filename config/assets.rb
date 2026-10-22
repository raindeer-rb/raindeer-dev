# frozen_string_literal: true

# Bundles component CSS/JS in "public" into "public/app.css" and "public/app.js".
module Assets
  extend self

  PUBLIC_PATH = File.expand_path('../public', __dir__)

  def build
    # Global styles first, so components can override them.
    write('app.css', ['style.css', *components('css')]) { |path, source| "/* #{path} */\n#{source}" }
    # Each script gets its own scope so top-level names can't collide.
    write('app.js', components('js')) { |path, source| "// #{path}\n(() => {\n#{source}\n})();" }
  end

  private

  # Files in "components", top level first then each folder down, alphabetical within a level.
  def components(extension)
    Dir.glob("components/**/*.#{extension}", base: PUBLIC_PATH).sort_by { |path| [path.count('/'), path] }
  end

  def write(output, paths)
    bundle = paths.map { |path| yield(path, File.read(File.join(PUBLIC_PATH, path))) }.join("\n\n")
    File.write(File.join(PUBLIC_PATH, output), "#{bundle}\n")
  end
end
