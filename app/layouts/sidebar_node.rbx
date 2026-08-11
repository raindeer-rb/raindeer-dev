# frozen_string_literal: true

class SidebarNode < LowNode
  Nav = Struct.new(:title, :links)
  Link = Struct.new(:title, :path)
  
  def initialize
    @navs = [
      Nav.new('Basics', [
        Link.new("Getting Started", "/docs/getting-started"),
        Link.new("Routing", "/docs/routing"),
        Link.new("Events", "/docs/events"),
        Link.new("Nodes", "/docs/nodes"),
        Link.new("Data", "/docs/data"),
      ]),
      Nav.new('Features', [
        Link.new("Types", "/docs/types"),
        Link.new("Templating", "/docs/templating"),
        Link.new("Static Site Generation", "/docs/static"),
        Link.new("Dead Man's Switch", "/docs/switch"),
      ]),
      Nav.new('Advanced', [
        Link.new("Dependencies", "/docs/dependencies"),
        Link.new("Pipelines", "/docs/pipelines"),
        Link.new("Architecture", "/docs/architecture"),
      ]),
      Nav.new('Tooling', [
        Link.new("CLI", "/docs/cli"),
        Link.new("Testing", "/docs/testing"),
        Link.new("Debugging", "/docs/debugging"),
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
