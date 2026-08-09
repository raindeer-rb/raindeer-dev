# frozen_string_literal: true

class PageRenderer < LowNode
  observe '/*'

  def initialize(event:)
    @pages = Providers['rain.pages']

    url_path = File.expand_path("app/pages#{event.route.path}", Dir.pwd)
    file_path = @pages.url_paths[url_path] || return

    result = @pages.process(file_path:)
    @html = result.html
    @title = result.metadata[:title]

    @published = @html && result.metadata[:published]
  end

  def render(event:)
    <{ if: @published }>
      <{ LayoutNode: }>
        <h1>{@title}</h1>

        <{ @html }>
      <{ :LayoutNode }>
    <{ :if }>
  end
end
