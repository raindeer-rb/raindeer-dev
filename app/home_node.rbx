# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def render
    <{ LayoutNode: }>
      <main id="content">
        <p>{"This file can be edited in 'app/home_node.rb'."}
      </main>
    <{ :LayoutNode }>
  end
end
