---
title: Routing
---

<{ :toc }>

Routes can be defined anywhere inside your `/app` folder. A new Raindeer application generated via `rain new app_name` will create `app/routes.rb`:

```ruby
Raindeer.router do
  get '/'
end
```

This route will accept GET requests.

Routes observe [RequestEvent](/docs/events#request-event)s (HTTP requests) and convert them into [RouteEvent](/docs/events#route-event)s. This RouteEvent can be observed by any [LowNode](/docs/nodes) and return a response or perform other workflows.

## Route Types

### Route

The `route` method accepts all HTTP verbs:

```ruby
Raindeer.router do
  route '/'
end
```
```

### HTTP Verb


```ruby

```

## Params

Parameters are dynamic sections of a URL that start with a colon (`:`) which become available as variables in a `RouteEvent`.

A `RouteEvent`s `@params` instance variable will contain a hash of every dynamic segment.

## Nested routes

Routes can be nested like so:

```ruby
Raindeer.router do
  get '/users' do # => RouteEvent
    get '/:id' # => RouteEvent
  end
end
```

The above route is functionalty equivalent to:

```ruby
Raindeer.router do
  get '/users/:id' # => RouteEvent
end
```

Both configurations trigger a `RouteEvent` for the `'/users/:id'` path, however the nested example will trigger an additional `RouteEvent` for the `'/users'` path. Whether there are any observers for that path is another question but it's perfectly okay to leave an event unobserved.

## Special events

While matching a request with a route is the most common use-case, additional events are triggered in the router lifecycle. These events happen in the following order:
1. `RouteEvent`
2. `WildcardRouteEvent`
3. `StatusEvent`

### Wildcard events

`'/*'` Represents every HTTP request. A `WildcardRouteEvent` event will be created and can be observed with `'/*'` when this route is defined.

> [!note]
> Return `nil` from `render` to move on to the next observer.

### Status events

When no route is found a `StatusEvent` will be sent to any observers of that particular server status, such as a "404". Observe the `Status` type followed by the status code; `observe Status[404]` and receive a `StatusEvent` when things go wrong.

## Architecture

`Rain::Router` is event-driven like other core components. It listens to `RequestEvent`s and converts them into `RouteEvent`s when a URL matches one of the defined routes.

`Raindeer.router` is syntactic sugar for `Providers['rain.router']`, which allows you to access a dependency from anywhere and as many times as you'd like. You may notice that a default Rainder application calls `Raindeer.router` in multiple locations per "feature"; this is in keeping with the compositional nature and ability of Raindeer... but by all means feel free to collate all the routes into one file if that's what you prefer.
