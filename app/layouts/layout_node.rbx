# frozen_string_literal: true

class LayoutNode < LowNode
  def render
    <html>
      <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="/syntax.css">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=DM+Mono:ital,wght@0,300;0,400;0,500;1,300;1,400;1,500&family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap" rel="stylesheet">
      </head>
      <body>
        <header>
          <div class="container">
            <a href="/"><span id="logo">{"Raindeer"}</span></a>
            <nav id="main-menu">
              <ul>
                <li><a href="/docs">{"Docs"}</a></li>
                <li><a href="https://github.com/raindeer-rb/raindeer">{"Source"}</a></li>
              </ul>
            </nav>
          </div>
        </header>
        
        <div class="container">
          <{ SidebarNode }>

          <main id="content">
            <{ :slot }>
          </main>
        </div>

        <footer>
          <div class="container">
            <ul>
              <li><a href="https://raindeer.dev">{"Website"}</a></li>
              <li><a href="https://raindeer.dev/docs">{"Docs"}</a></li>
              <li><a href="https://github.com/raindeer-rb/raindeer">{"GitHub"}</a></li>
            </ul>
          </div>
        </footer>
      </body>
    </html>
  end
end
