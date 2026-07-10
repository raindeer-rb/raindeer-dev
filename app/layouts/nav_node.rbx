# frozen_string_literal: true

class NavNode < LowNode
  def initialize(event:, nav:)
    @nav = nav
    @links = nav.links
  end

  def render
    <details open>
      <summary>{@nav.title}</summary>
      <ul>
        <{ for: link in: @links }>
          <li><a href="{link.path}">{link.title}</a></li>
        <{ :for }>
      </ul>
    </details>
  end
end
