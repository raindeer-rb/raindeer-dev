# frozen_string_literal: true

class Layout < LowNode
  def initialize
    @description = "An event-driven and compositional web framework that's easy to use 🦌"
  end

  def render(event:, section:, title:)
    <html lang="en">
      <head>
        <title>{"Raindeer"} - {title}</title>

        <meta charset="UTF-8">
        <meta name="description" content="{@description}">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        <link rel="stylesheet" href="/app.css">
        <script src="/app.js" defer></script>
        <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🦌</text></svg>">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=DM+Mono:ital,wght@0,300;0,400;0,500;1,300;1,400;1,500&family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">

        <meta property="og:image" content="https://raindeer.dev/assets/cover.png" />
        <meta property="og:title" content="Raindeer - {title}" />
        <meta property="og:description" content="{@description}" />
        <meta property="og:url" content="https://raindeer.dev" />
        <meta property="og:type" content="website" />
      </head>
      <body class="{section}">
        <div id="background"></div>

        <header>
          <div class="container">
            <a id="logo" href="/">{"Raindeer"}</a>
            <nav id="main-menu">
              <ul>
                <li><a href="/docs/getting-started"><i class="bi bi-book"></i>{"Docs"}</a></li>
                <li><a href="/gems"><i class="bi bi-gem"></i>{"Gems"}</a></li>
                <li><a href="https://github.com/raindeer-rb/raindeer"><i class="bi bi-github"></i> {"Source"}</a></li>
              </ul>
            </nav>
          </div>
        </header>
        
        <main class="container">
          <{ :slot }>
        </main>

        <footer>
          <div class="container">
            <ul>
              <li><a href="https://reddit.com/r/raindeer"><i class="bi bi-reddit"></i>{"Reddit"}</a></li>
              <li><a href="https://discord.gg/UBex4JQgnX"><i class="bi bi-discord"></i>{"Discord"}</a></li>
              <li><a href="https://www.rubyforum.org/tag/raindeer/97"><i class="bi bi-chat-square-text"></i>{"Forum"}</a></li>
              <li><a href="https://github.com/raindeer-rb/raindeer"><i class="bi bi-github"></i>{"GitHub"}</a></li>
            </ul>
          </div>
        </footer>
      </body>
    </html>
  end
end
