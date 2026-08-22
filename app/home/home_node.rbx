# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def initialize(event:)
    @cards = Raindeer.pages.list(folder: 'cards')
  end

  def render(event:)
    <{ Layout: section='section-home' }>
      <img id="raindeer" src="/assets/logo.png"/>

      <div id="overview">
        <p>{"Raindeer is an event-driven framework using the dynamic features and latest async improvements in Ruby + some weird ideas, to build a new breed of web application. "}</p>
        <p><strong>{"Deer to be different."}</strong></p>
        <p class="actions"><a href="/docs/getting-started" role="button"><i class="bi bi-book"></i>{"Getting Started"}</a></p>
      </div>

      <div id="cards" class="grid">
        <{ for: card in: @cards }>
          <{ Card card=card }>
        <{ :for }>
      </div>

      <div class="teaser">
        <img src="/assets/sudoku.png"/>
        <div class="content">
          <p>
            <em>{"Raindeer was born out of a Sudoku solver... "}</em><br />
            {"It wasn't extracted from a traditional web application, but created from first principles of what an easy to use yet performant framework would be."}
          </p>
          <p><a href="/docs/architecture" role="button"><i class="bi bi-stack"></i>{"See Architecture"}</a></p>
        </div>
      </div>

      <h2 align="center">{"Diff"}</h2>

      <div id="pros-cons">
        <ul class="icons cons">
          <li>{"Rack"}</li>
          <li>{"Model-View-Controller"}</li>
          <li>{"Namespaces (optional)"}</li>
          <li>{"Individual template files"}</li>
          <li>{"Build steps"}</li>
        </ul>

        <ul class="icons pros">
          <li>{"Event Loop"}</li>
          <li>{"Composition"}</li>
          <li>{"Inline types (optional)"}</li>
          <li>{"Auto loaded files"}</li>
          <li>{"Events"}</li>
          <li>{"Pipelines"}</li>
          <li>{"Repository pattern"}</li>
        </ul>
      </div>
    <{ :Layout }>
  end
end
