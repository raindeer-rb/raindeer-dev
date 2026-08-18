# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def initialize(event:)
    file_paths = Raindeer.pages.tagged(folder: 'cards')
    @cards = Raindeer.pages.list(file_paths:)
  end

  def render(event:)
    <{ LayoutNode: }>
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
        </div>
      </div>

      <h2 align="center">{"Philosophy..."}</h2>

      <div id="pros-cons">
        <ul class="icons cons">
          <li>{"Rack"}</li>
          <li>{"Model-View-Controller"}</li>
          <li>{"Namespaces (optional)"}</li>
          <li>{"Individual template files"}</li>
          <li>{"Build steps"}</li>
        </ul>

        <ul class="icons pros">
          <li>{"Concurrency (Async, Fibers, Ractors)"}</li>
          <li>{"Composition (RBX, Nodes, Data Expressions)"}</li>
          <li>{"Inline types (optional)"}</li>
          <li>{"Auto loaded files"}</li>
          <li>{"Routes as events"}</li>
          <li>{"Everything's a pipeline"}</li>
          <li>{"Repository pattern"}</li>
        </ul>
      </div>
    <{ :LayoutNode }>
  end
end
