# frozen_string_literal: true

class Status404Node < LowNode
  observe Status[404]
  # Exported by "rain build" to "build/404.html", which Cloudflare Pages serves for missing pages.
  observe '/404'

  def initialize
    @title = 'Page not found'
  end

  def render
    <{ Layout: title=@title section='section-404' }>
      <div class="status-404">
        <div class="page-intro">
          <h1>{"Page not found"}</h1>
          <p>{"This page doesn't exist, or it has moved."}</p>
        </div>

        <p class="actions">
          <a href="/docs/getting-started" role="button"><i class="bi bi-book"></i>{"Read the docs"}</a>
          <a href="/" role="button" class="secondary"><i class="bi bi-house"></i>{"Home"}</a>
        </p>
      </div>
    <{ :Layout }>
  end
end
