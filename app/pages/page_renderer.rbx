# frozen_string_literal: true

class PageRenderer < LowNode
  observe '/*'

  def initialize(event:)
    @pages = Providers['rain.pages']

    url_path = File.expand_path("app/pages#{event.route.path}", Dir.pwd)
    file_path = @pages.url_paths[url_path] || return

    @result = @pages.render(file_path:)
  end

  def render(event:)
    <{ if: @result }>
      <{ LayoutNode: }>
        <{ @result }>
      <{ :LayoutNode }>
    <{ :if }>
  end
end
