---
title: Static Site Generation
published: true
---

<{ :toc }>

<p class="slogan">Start static, go dynamic</p>

Raindeer is a dynamic web framework but it can also export markdown files to a static site. This allows for a site that can start off static and become dynamic, or the reverse. In fact, this very [documentation site](https://github.com/raindeer-rb/raindeer-dev) is generated from a Raindeer application.

## File Structure

Place your markdown files in `app/pages`.

### URLs

**File paths define the URL:** A path of `app/pages/docs/static.md` will result in the URL `http://example.com/docs/static`.
- Prefix folders with an underscore to group files without affecting the URL:
  `app/pages/docs/_basics/static.md` => `/docs/static`
- Prefix file names with an underscore and number to order files without affecting the URL:
  `app/pages/docs/_1-getting-started.md` => `/docs/getting-started`

**The humble underscore:** In summary, an underscore `_` followed by a string or number until a `-` or `/` adds metadata to a folder/file whilst hiding that part of the filepath from the URL.

### Assets

Put publicly accessible assets such as images and files in the `/public` folder. The URL for a file like `/public/logo.png` will be `/logo.png`.

#### Bundles

Raindeer can combine your CSS and JavaScript files into bundles, so each page loads one stylesheet and one script. List each bundle and its files under `assets` in `config/config.yaml`:

```yaml
assets:
  app.css:
    - style.css
    - components/*
    - components/*/*
  app.js:
    - components/*/*
```

Paths are relative to `/public`, and each bundle is written there too, so `/public/app.css` is served at `/app.css`:

```html
<link rel="stylesheet" href="/app.css">
<script src="/app.js" defer></script>
```

- **Order:** Files are added in the order they're listed.
- **Wildcards:** A path with a wildcard adds the files it matches in alphabetical order. `components/*` matches the files directly in `components`, `components/*/*` matches the files one folder down and `components/**/*` matches every file at any depth.
- **Extensions:** A wildcard only adds files with the bundle's extension, so `app.css` skips `.js` files. A file is only added once, and a bundle never includes itself.
- **Output:** Each CSS file is labelled with a comment, and each JavaScript file is wrapped in its own scope so top-level names can't collide between files.

The dev server builds the bundles when it starts, and with `debug_mode` on it rebuilds them whenever one of their files is saved, added or deleted. `rain build` builds them before exporting, so a fresh checkout deploys without an extra step.

Bundles are generated, so add them to `.gitignore`:

```
/public/app.css
/public/app.js
```

## Markdown

[GitHub flavoured markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) is supported out of the box.

**Required Frontmatter:**

- `title` - Used by your site's theme layer
- `published` - Whether to export the page to the build

```markdown
---
title: Heading 1
published: true
---

## Heading 2
```

## Raindown

In addition to Markdown, Raindown provides macros to make working with Markdown files easier.

### Table of Contents

Insert a table of contents that links to each heading on your page:
```ruby
<{ :toc }>
```

### Quote [UNRELEASED]

Insert a `<blockquote>` with correct `<figure>` semantics and author attribution:

```ruby
<{ quote: 'Name' }>
  The sentence said by some guy who died
<{ :quote }>
```

### List

List markdown files, filtered by specified metadata:

```ruby
<{ list: item folder: 'basics' }>
  {item.title}
<{ :list }>
```

**Available metadata:**
- `title` - *example:* "Getting Started"
- `path` - *example:* "docs/getting-started"
- `folder` - *example:* "basics"
- `order` - *example:* 1
- [Metadata](#metadata) defined in the frontmatter of the markdown files

List items are sorted by `order` by default. Change the ordering with:

```ruby
<{ list: item folder: 'basics' order: :created_at }>
  {item.title}
<{ :list }>
```

### Embed [UNRELEASED]

Include the contents of another markdown file:

```ruby
<{ embed: "/components/our-story.md" }>
```

> [!note]
> File paths can be relative (`../`) or absolute (`/`)

### Custom Component

Use [nodes](/docs/nodes) and Antlers to create custom components with their own HTML and access to Ruby.

First define your component:
```ruby
class CustomComponent < LowNode
  def render
    <html>{"Any text that you can dream of"}</html>
  end
end
```

Then call it in a Markdown/Raindown file:
```ruby
<{ CustomComponent }>
```

> [!WARNING]
> If you namespace your component then you need to configure that namespace in Raindown

## Metadata

Metadata is made available to Raindown macros (such as ["List"](#list)) and the Raindeer application (See ["Layout"](#layout)).

### Explicit metadata

Add metadata via the markdown file's frontmatter:
```markdown
---
tags: ['tag_1', 'tag_2', 'tag_3']
date: 2099
---
```

### Implicit metadata

#### Folder tags

Underscored values in file paths are automatically converted to metadata. For example, in the following file path...
```
app/pages/docs/_basics/_1-getting-started.md
```

...the `_basics` and `_1` prefixes produce metadata that is equivalent to the following frontmatter:
```markdown
---
folder: basics
order: 1
path: /docs/getting-started
---
```

`path` is automatically available too without manual entry, representing the absolute URL path.

> [!NOTE]
> Separate multiple folder tags with `&`:
> `app/pages/docs/_1&_basics/_1-getting-started.md`

#### Label tags [UNRELEASED]

Any uppercase text between two square brackets `[]` is considered a label tag. This is useful for defining the current status of an article, project or feature. For example:
- [DRAFT]
- [BETA]
- [UNRELEASED]

A label tag can be put in `title:` frontmatter or `## heading` and **NOT** have its characters visible in the URL or anchor link. Additionally it outputs CSS classes for more label-like styling.

## Collections

Collections are arrays of records that can be rendered anywhere; a page, a node, and *optionally* accessed directly via URL. Unlike other static site generators, you don't need to configure where collections live. Using the two established patterns of *The humble underscore™* and *Implicit metadata*, simply put underscore prefixed markdown files in underscore prefixed folders.

**For example:**
```
/app/pages/_cards/_fast.md
```

The `_cards` adds `folder: cards` metadata to every child file while hiding the folder from the URL, and the `_fast.md` hides the file from the URL. This file is now accessible only through metadata. Render these files elsewhere with lists:

### Rendering in a page

```ruby
<{ list: card folder: 'cards' }>
  {card.title}
<{ :list }>
```

### Rendering in a node

```ruby
class CardsNode < LowNode
  def initialize
    @cards = Raindeer.pages.list(folder: 'cards')
  end

  def render
    <{ for: card in: @cards }>
      {card.title}
    <{ :for }>
  end
end
```

## Layout

By default a [new](/docs/cli#rain-new-app_name) Raindeer application contains a `PageRenderer` that `render`s a markdown file that matches the URL request. In this file you can wrap a `LayoutNode` around the page's HTML output, just like you would do in a typical Raindeer application.

## Building

Raindeer bypasses the normal async server when building a static site, requesting routes and their corresponding markdown files directly in-process.

To export `app/pages` to a static site run:
```bash
rain build
```

This exports a package of typical website files in the `/build` folder that can be uploaded to any web service that accepts static sites such as GitHub, GitLab, Cloudflare and Codeberg Pages.

### Cloudflare

Cloudflare Pages serves a top-level `404.html` for missing pages, with a 404 status. Without one, it assumes your site is a single-page app and serves the home page with a 200 status instead, so every broken link looks like a working copy of your home page.

`rain build` exports pages and routes but not status pages, so to give Cloudflare a `404.html`:

**1. Render the page for a route too.** Have your 404 node also observe a `/404` route, alongside `Status[404]` for the dev server:

```ruby
# app/statuses/status_404_node.rbx
class Status404Node < LowNode
  observe Status[404]
  observe '/404'

  def render
    <{ Layout: title='Page not found' }>
      <h1>{"Page not found"}</h1>
    <{ :Layout }>
  end
end
```

**2. Add the route,** so that `rain build` exports it to `build/404/index.html`:

```ruby
# app/routes.rb
Raindeer.router do
  get '/404'
end
```

**3. Move it after building.** Add a script that moves the page to `build/404.html`:

```ruby
#!/usr/bin/env ruby
# bin/404
require 'fileutils'

build_path = File.expand_path('../build', __dir__)
FileUtils.mv(File.join(build_path, '404', 'index.html'), File.join(build_path, '404.html'))
FileUtils.rmdir(File.join(build_path, '404'))
```

Make it executable with `chmod +x bin/404`, then set your Cloudflare Pages build command to run it after building:

```bash
rain build && bin/404
```

Use the gem's `rain` here rather than a `bin/rain` that requires `bundler/setup`. Cloudflare installs gems without your `development` and `test` groups, but only for the install step, so `bundler/setup` fails looking for them.

After deploying, check that a missing page returns a 404:

```bash
curl -I https://example.com/no-such-page
```
