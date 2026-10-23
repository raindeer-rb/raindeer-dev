---
title: Contributing
published: true
---

<{ :toc }>

Bug reports and pull requests are welcome on the associated repository:

- [Low](https://github.com/orgs/low-rb/repositories)
- [Raindeer](https://github.com/orgs/raindeer-rb/repositories)

Repositores are split into 2 main categories; building blocks or the wiring that connects them together. Raindeer is one large repository containing many feature-level components, however it contains 2 cross cutting concerns; Router and Pipelines.

<img src="/assets/repository-map.svg" alt="Repository Map"/>

## Setup

In your terminal run:
```shell
bundle install
```

Start the server:
```
bin/server
```

> [!TIP]
> `bin/server` as opposed to `rain server` ensures you're working with local gems

**iTerm:** You may need to press `Option + A` to accept screen refreshing.

## Testing

Run all tests with `bundle exec rspec`.
Add the `SHOW_OUTPUT=1` flag to see the terminal output from some of the feature tests.

## Guidelines

### AI

Some repos are "human-first" and for these you use AI to augment and poke holes. Other repos are "AI-first" with a human guiding the output. AI is great in general for researching a codebase, asking questions, finding bugs and generating benchmarks.

### `.[]` Syntax

Raindeer uses the `[]` class syntax a lot, but it does so within reason. Our guiding rule is:

> The `[]` syntax should access and define collections, not act solely as a constructor

While it's tempting to use this syntax as a "constuctor" for modules (`MyModule[config:]`), it's actually counter productive, it muddies the waters. Users should see `[]` and instantly know that they're accessing or definining a collection of objects, not constructing or returning a single object. Just use `.new()` or call a named method.
