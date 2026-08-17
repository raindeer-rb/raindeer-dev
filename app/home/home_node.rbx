# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def initialize(event:)
    file_paths = Raindeer.pages.tagged(folder: 'cards')
    @cards = Raindeer.pages.list(file_paths:)
  end

  def render(event:)
    <{ LayoutNode: }>
      <div id="cards" class="grid">
        <{ for: card in: @cards }>
          <{ Card card=card }>
        <{ :for }>
      </div>
    <{ :LayoutNode }>
  end
end
