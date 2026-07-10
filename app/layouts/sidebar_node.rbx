# frozen_string_literal: true

class SidebarNode < LowNode
  Nav = Struct.new(:title, :links)
  Link = Struct.new(:title, :path)
  
  def initialize
    @navs = [
      Nav.new('Basics', [
        Link.new("Getting Started", "/docs/getting-started"),
        Link.new("Events", "/docs/events"),
        Link.new("Nodes", "/docs/nodes"),
        Link.new("Routing", "/docs/routing"),
      ]),
      Nav.new('Features', [
        Link.new("Forms", "/docs/forms"),
        Link.new("Static", "/docs/static"),
      ]),
    ]
  end

  def render
    <aside id="sidebar">
      <nav id="docsnav">
        <{ for: nav in: @navs }>
          <{ NavNode nav=nav }>
        <{ :for }>
      </nav>
    </aside>
  end
end
