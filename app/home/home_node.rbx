# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def initialize(event:)
    file_paths = Raindeer.pages.tagged(folder: 'cards')
    @cards = Raindeer.pages.list(file_paths:)
  end

  def render(event:)
    <{ LayoutNode: }>
      <img id="raindeer" src="/assets/logo.png" width="350"/>

      <div id="overview">
        <p>{"Raindeer is an event-driven framework using the dynamic features and latest async improvements in Ruby + some weird ideas, to build a new breed of web application. "}</p>
        <p><strong>{"Deer to be different."}</strong></p>
      </div>

      <div id="cards" class="grid">
        <{ for: card in: @cards }>
          <{ Card card=card }>
        <{ :for }>
      </div>
    <{ :LayoutNode }>
  end
end
