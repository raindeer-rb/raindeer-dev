---
title: Routing
published: true
---

<{ :toc }>

Routes can be defined anywhere inside your `/app` folder. A new Raindeer application generated via `rain new :app_name` will create `app/routes.rb`.

The router observes [RequestEvent](/docs/events#request-event)s (HTTP requests), matches them to a `Route` and converts them into [RouteEvent](/docs/events#route-event)s. This `RouteEvent` can be observed by any [node](/docs/nodes) and return a response.

## Implicit routes

You can use simple strings to define a `Route`. Matching HTTP requests are automatically forwarded to a `render` or `receive` method on the node.

```ruby
Raindeer.router do
  route '/'
end
```

Then `observe '/'` this route in a node. **See:** [Observing](/docs/nodes#implicit-syntax)

## Explicit routes

```ruby
Raindeer.router do
  route GET => '/'
  route QUERY => '/'
  route POST => '/'
  route PUT => '/'
  route PATCH => '/'
  route DELETE => '/'
end
```

Then `observe Route[GET => '/']` this route in a node, replacing `GET` with the desired HTTP verb. **See:** [Observing](/docs/nodes#explicit-syntax)

Support multiple route types at once with:
```ruby
Raindeer.router do
  route [GET, POST] => '/:user_id'
end
```

## Params

Parameters are dynamic sections of a URL that start with a colon (`:`) which become available as variables in a `RouteEvent`.

A `RouteEvent`s `@params` instance variable will contain a hash of every dynamic segment.

## Nested routes

Routes can be nested like so:

```ruby
Raindeer.router do
  route GET => '/users' do
    route GET => '/:id'
  end
end
```

The above route is functionalty equivalent to:

```ruby
Raindeer.router do
  get '/users/:id'
end
```

### Mid Nodes

Both configurations trigger a `RouteEvent` for the `'/users/:id'` path, however the nested example will trigger an additional `RouteEvent` for the `'/users'` path. Whether there are any observers for that path is another question as it's perfectly okay to leave an event unobserved.

Observe part of a path with `recon`:

```ruby
class WatchfulEye < LowNode
  observe '/users'

  # Will not be called on '/users' but on '/users/*'.
  def recon(event: RouteEvent)
    # Conditionally override the response or log etc.
  end
end
```

## Special events

While matching a request with a route is the most common use-case, additional events are triggered in the router lifecycle. These events happen in the following order:
1. `RouteEvent`
2. `WildcardRouteEvent`
3. `StatusEvent`

### Wildcard events

`'/*'` Represents every unrouted HTTP request. A `WildcardRouteEvent` event can be observed with `'/*'` when this route is defined.

> [!TIP]
> Return `nil` from `render` to move on to the next observer

Wildcard events occur after routing so that routing is as fast as possible. If you want to do something before every request then redefine [RequestEvent](/docs/events#requestevent).

### Status events

When no route is found a `StatusEvent` will be triggered, such as a "404". Observe the `Status` type followed by the status code; `observe Status[404]` and receive a `StatusEvent` when things go wrong.

## Architecture

The router is a prefix tree! Also known as a Trie. It's pretty [performant](/docs/benchmarks).

`Rain::Router` is event-driven like other core components. It observes `RequestEvent`s and creates `RouteEvent`s when a URL matches one of the defined routes.

You can call `Raindeer.router` in multiple files per "feature"; this is in keeping with the compositional nature of Raindeer... but by all means feel free to collate all your routes into one file if that's what you prefer.
