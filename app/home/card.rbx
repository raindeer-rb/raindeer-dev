# frozen_string_literal: true

class Card < LowNode
  def render(event:, card:)
    <article class="card">
      <header>
        <h3>
          <{ if: card.title_icon }>
            <i class="bi bi-{card.title_icon}"></i>
          <{ :if }>

          {card.title}
        </h3>
      </header>

      <div class="content">
        <{ if: card.icon }>
          <i class="bi bi-{card.icon}"></i>
        <{ :if }>

        <p>{card.summary}</p>
        <{ card.content }>
      </div>
    </article>
  end
end
