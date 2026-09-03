# frozen_string_literal: true

class Layout < LowNode
  def render(event:, section:)
    <html>
      <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="/components/home.css">

        <!-- TODO: Precompile. -->
        <link rel="stylesheet" href="/components/alerts.css">
        <link rel="stylesheet" href="/components/contributors.css">
        <link rel="stylesheet" href="/components/sidebar/sidebar.css">
        <script src="/components/sidebar/sidebar.js" defer></script>
        <link rel="stylesheet" href="/components/toc/toc.css">
        <script src="/components/toc/toc.js" defer></script>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=DM+Mono:ital,wght@0,300;0,400;0,500;1,300;1,400;1,500&family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">

        <meta property="og:image" content="https://raindeer.dev/assets/cover.png" />
        <meta property="og:title" content="Raindeer" />
        <meta property="og:description" content="An event-driven and compositional web framework that's easy to use 🦌" />
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
                <li><a href="https://github.com/raindeer-rb/raindeer"><i class="bi bi-github"></i> {"Source"}</a></li>
              </ul>
            </nav>
          </div>
        </header>
        
        <main class="container overflow-auto">
          <{ :slot }>
        </main>

        <footer>
          <div class="container">
            <ul>
              <li><a href="https://reddit.com/r/raindeer">{"Reddit"}</a></li>
              <li><a href="https://discord.gg/UBex4JQgnX">{"Discord"}</a></li>
              <li><a href="https://www.rubyforum.org/tag/raindeer/97">{"Forum"}</a></li>
              <li><a href="https://github.com/raindeer-rb/raindeer">{"GitHub"}</a></li>
            </ul>
          </div>
        </footer>
      </body>
    </html>
  end
end
