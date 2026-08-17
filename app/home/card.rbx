# frozen_string_literal: true

class Card < LowNode
  def render(event:, card:)
    <article class="card">
      <header>
        <h3>{card.title}</h3>
      </header>

      <div class="content">
        <p>{card.summary}</p>
        <{ card.content }>
      </div>
    </article>
  end
end
