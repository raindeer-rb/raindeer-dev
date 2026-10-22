# frozen_string_literal: true

class HomeNode < LowNode
  observe '/'

  def initialize(event:)
    @title = 'An event-driven and compositional web framework'
    @cards = Raindeer.pages.list(folder: 'cards')
  end

  def render(event:)
    <{ Layout: title=@title section='section-home' }>
      <img id="raindeer" src="/assets/logo.png" alt="Raindeer logo, an illustrated deer with large antlers"/>

      <div id="overview">
        <p>{"Raindeer is an event-driven framework using the dynamic features and latest async improvements in Ruby + some weird ideas, to build a new breed of web application. "}</p>
        <p><strong>{"Deer to be different."}</strong></p>
        <p class="actions"><a href="/docs/getting-started" role="button"><i class="bi bi-book"></i>{"Getting Started"}</a></p>
        <{ Version }>
      </div>

      <div id="cards" class="grid">
        <{ for: card in: @cards }>
          <{ Card card=card }>
        <{ :for }>
      </div>

      <div class="teaser">
        <img src="/assets/sudoku.png" alt="A Sudoku grid with some squares filled in blue"/>
        <div class="content">
          <h2>{"Raindeer was born out of a Sudoku solver... "}</h2>
          <p>{"It wasn't extracted from a traditional web application, but created from first principles of what an easy to use yet performant framework would be."}</p>
          <p><a href="/docs/architecture" role="button"><i class="bi bi-stack"></i>{"See Architecture"}</a></p>
        </div>
      </div>

      <h2 align="center">{"Diff"}</h2>

      <div id="diff">
        <div class="diff-header">
          <div class="del">{"Traditional"}<span class="count">{"−5"}</span></div>
          <div class="add">{"Raindeer"}<span class="count">{"+7"}</span></div>
        </div>

        <div class="diff-row">
          <div class="del"><span class="num">{"1"}</span><span class="sign">{"−"}</span>{"Rack"}</div>
          <div class="add"><span class="num">{"1"}</span><span class="sign">{"+"}</span>{"Event Loop"}</div>
        </div>
        <div class="diff-row">
          <div class="del"><span class="num">{"2"}</span><span class="sign">{"−"}</span>{"Model-View-Controller"}</div>
          <div class="add"><span class="num">{"2"}</span><span class="sign">{"+"}</span>{"Composition"}</div>
        </div>
        <div class="diff-row">
          <div class="del"><span class="num">{"3"}</span><span class="sign">{"−"}</span>{"Namespaces"}</div>
          <div class="empty"></div>
        </div>
        <div class="diff-row">
          <div class="del"><span class="num">{"4"}</span><span class="sign">{"−"}</span>{"Individual template files"}</div>
          <div class="empty"></div>
        </div>
        <div class="diff-row">
          <div class="del"><span class="num">{"5"}</span><span class="sign">{"−"}</span>{"Build steps"}</div>
          <div class="empty"></div>
        </div>
        <div class="diff-row">
          <div class="empty"></div>
          <div class="add"><span class="num">{"3"}</span><span class="sign">{"+"}</span>{"Inline types (optional)"}</div>
        </div>
        <div class="diff-row">
          <div class="empty"></div>
          <div class="add"><span class="num">{"4"}</span><span class="sign">{"+"}</span>{"Auto loaded files"}</div>
        </div>
        <div class="diff-row">
          <div class="empty"></div>
          <div class="add"><span class="num">{"5"}</span><span class="sign">{"+"}</span>{"Events"}</div>
        </div>
        <div class="diff-row">
          <div class="empty"></div>
          <div class="add"><span class="num">{"6"}</span><span class="sign">{"+"}</span>{"Pipelines"}</div>
        </div>
        <div class="diff-row">
          <div class="empty"></div>
          <div class="add"><span class="num">{"7"}</span><span class="sign">{"+"}</span>{"Repository pattern"}</div>
        </div>
      </div>
    <{ :Layout }>
  end
end
