# frozen_string_literal: true

class SidebarNode < LowNode
  Nav = Struct.new(:title, :links)
  Link = Struct.new(:title, :path)

  def initialize
    @navs = ['Basics', 'Connections', 'Features', 'Advanced', 'Tooling'].map do |folder|
      list = Raindeer.pages.list(folder: folder.downcase.gsub(' ', '_'))
      Nav.new(folder, list)
    end
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
