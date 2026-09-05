---
title: Middleware
published: true
---

<{ :toc }>

Raindeer doesn't use Rack or a traditional middleware API. A middleware is just a pipeline, and in Raindeer everything is a pipeline already. Intercepting the request or response layer can be done in a few different ways. Below they are listed in the order in which they are executed.

## Events

### 1. `BootEvent` [CANDIDATE]

While you could edit your boot file in `config/boot.rb` to set things up before or after `require 'raindeer/boot'`, `BootEvent` provides a more formal API.

### 2. `RequestEvent`

Say you want to authenticate, log or redirect before every request, then `RequestEvent.define` is the answer. We do it this way to minimise per-request overhead; if you're handling thousands of requests then you don't want to be processing nice tasty `RouteEvent`s before denying access or issuing redirects.

```ruby
Low::Events::RequestEvent.define do |observers|
  observers = [MyLogger, MyAuthenticator, *observers]
end
```

These new observers will receive a `:request` action, so add a `request` method to those classes and return `LowNode.render(event:)`, [ResponseEvent](#responseevent) or `nil`.

> [!TIP]
> Event observers should only be redefined once, so keep them in a central location. **Example:** `app/events/request_event`

### 3. `RouteEvent`

Because you can listen to "mid-nodes" along a route, you can `observe '/'` with a `side_effect` action/method to intercept **every** routed request.

### 4. `WildcardEvent`

The router's unmatched requests will not be routed, but a `WildcardEvent` will then be called.

### 5. `StatusEvent`

Observe `Status[404]` or similar for when nothing above returns a non-nil reponse.

## Pipeline Data Flow

Events are Push-based (trigger event) **and** Pull-based (return value). Code that triggers an event receives the output of that event, which may be the output of another sub event and so on.
