# frozen_string_literal: true

class PageRenderer < LowNode
  observe '/*'

  def initialize(event:)
    page = Providers['rain.pages'].page(path: event.route.path) || return

    @html = page.html
    @title = page.metadata[:title]
    @published = @html && page.metadata[:published]
  end

  def render
    <{ if: @published }>
      <{ LayoutNode: }>
        <{ SidebarNode }>

        <main id="content">
          <h1>{@title}</h1>

          <{ @html }>
        </main>
      <{ :LayoutNode }>
    <{ :if }>
  end
end
