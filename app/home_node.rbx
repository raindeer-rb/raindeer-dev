# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def render
    <{ LayoutNode: }>
      <p>{"This file can be edited in 'app/home_node.rb'."}
    <{ :LayoutNode }>
  end
end
