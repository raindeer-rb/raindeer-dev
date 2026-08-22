# frozen_string_literal: true

class NavLink < LowNode
  def initialize(event:, link:)
    @title = link.menu ? link.menu : link.title
    @path = link.path
  end

  def render
    <li><a href="{@path}">{@title}</a></li>
  end
end
