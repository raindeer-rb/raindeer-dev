---
title: Static Site Generation
---

<div id="hero">
  <p class="subtitle">Start static, go dynamic</p>
</div>

Raindeer is a dynamic web framework, however you can also use it to export markdown files to a static site. This allows for a site that can start off static and become dynamic, or the reverse. In fact, this very documentation site is generated from a Raindeer application.

## File Structure

Place your markdown files in `app/pages`.

### URLs

File paths will define the URL, for example; a path of `app/pages/docs/static.md` will result in the URL **"http://example.com/docs/static"**.
- Folders prefixed with an underscore such as `app/pages/docs/_basics/static.md` can be used to group files internally but will be stripped from the URL
- File names prefixed with an underscore and number such as `_1-getting-started.md` can be used to order files but will also be stripped from the URL

### Assets

Place public facing assets such as images and files in the `/public` directory. The URL for a file like `/public/logo.png` will be `/logo.png`.

## Markdown

[GitHub flavoured markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) is supported out of the box.

The only Frontmatter metadata required is `title`, which will be used by your site's theme layer:
```markdown
---
title: Heading 1
---

## Heading 2
```

## Raindown

In addition to Markdown, Raindown provides macros to make working with Markdown files easier.

### Table of Contents [UNRELEASED]

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

### List [UNRELEASED]

List markdown files, filtered by specified metadata:

```ruby
<{ list: item folder: 'basics' }>
  <{ item.title }>
<{ :list }>
```

**Available metadata:**
- `title` - *example:* "Getting Started"
- `path` - *example:* "docs/getting-started"
- `folder` - *example:* "basics"
- `order` - *example:* 1
- ["Metadata"](#metadata) defined in the frontmatter of the markdown files

List items are sorted by `order` by default. Change the ordering with:

```ruby
<{ list: item folder: 'basics' order: :created_at }>
  <{ item.title }>
<{ :list }>
```

### Include [UNRELEASED]

Embed the contents of another markdown file:

```ruby
<{ "/components/our-story.md" }>
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

> [!warning]
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

Underscored values in file paths are automatically converted to metadata. For example, in the following file path...
```
app/pages/docs/_basics/_1-getting-started.md
```

...the `_basics` and `_1` prefixes produce metadata that is equivalent to the following frontmatter:
```markdown
folder: basics
order: 1
```

## Layout

By default a new Raindeer application contains a `PageNode` that `render`s a markdown file when it matches a URL request. In this file you can wrap a `LayoutNode` around the `MarkdownRenderer`, just like you would do in a typical Raindeer application.

## Exporting

To export `app/pages` to a static site run:
```bash
rain pages build
```

This exports a package of typical website files in the `/pkg` folder that can be uploaded to any web service that accepts static sites such as GitHub, GitLab, Cloudflare and Codeberg Pages.
