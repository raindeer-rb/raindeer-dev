---
title: Events
published: true
---

<{ :toc }>

Raindeer is an event-driven framework that represents the Request-Response lifecycle as events. It's easy to latch on to any event as they happen and perform additional tasks.

> [!NOTE]
> Raindeer is event-driven internally but your application doesn't have to be. In fact, Raindeer's main events are abstracted away to such a degree that you can ignore them.

## Request-Response Lifecycle

1. [RequestEvent](/docs/events#requestevent) - The server converts HTTP requests into request events
2. [RouteEvent](/docs/events#routeevent) - The [router](/docs/routing) creates route events from request events
3. [RenderEvent](/docs/events#renderevent) - A [node](/docs/nodes) observes a route event and renders a response
4. [ResponseEvent](/docs/events#responseevent) - A response event is converted into an HTTP response and given to the requester

## Observing Events

### `observe` syntax

Observe the event with:

```ruby
class MyNode < LowNode
  observe MyEvent

  def render
    "My Response"
  end
end
```

### `on` syntax [UNRELEASED]

Better distinguish event handlers from regular methods in a class with:

```ruby
on MyEvent do |my_event|
  # Do something.
end
```

Observe a particular action:
```ruby
on MyEvent => :my_action do |my_event|
  # Do something.
end
```

*Breakdown:*
- Class level scope
- Returns a value
- Not for returning RBX (yet)
- More performant (needs benchmarking)

**See also:** [Observers](/docs/observers)

## Events Types

### `RequestEvent`

The `RequestEvent` contains a `request` attribute, which is a [Protocol::HTTP::Request](https://github.com/socketry/protocol-http/blob/main/lib/protocol/http/request.rb) provided by [Protocol::HTTP](https://socketry.github.io/protocol-http/). It is also responsible for [keeping track](#event-tree) of every subsequent event.

#### Ordering Observers

Say you want to authenticate, log or redirect before every request, then `RequestEvent.define` is the answer. We do it this way to minimise per-request overhead; if you're being [DDoS'd](https://en.wikipedia.org/wiki/Denial-of-service_attack) then why give them the satisfaction or processing a nice tasty `RouteEvent` for them before denying their request?

```ruby
Low::Events::RequestEvent.define do |observers|
  observers = [MyLogger, MyAuthenticator, *observers]
end
```

These new observers will receive a `:request` action, so add a `request` method to these classes and return a `LowNode.render(event:)`, a [ResponseEvent](#responseevent) or `nil`.

> [!TIP]
> Event observers should only be redefined once, so keep them in a central location. **Example:** `app/events/request_event`

### `RouteEvent`

Observe a [route](/docs/routing) and it will trigger the `render` action/class method on a [node](/docs/nodes)/observer. The *method factory pattern* takes over; instantiating the node with a `RenderEvent`, before calling the instance `render` method with the same `RenderEvent`.

### `RenderEvent`

Calls `render` instance method by defalult, after observing a route or rendering a node via Antlers in the template.

### `ResponseEvent`

Attribute `response` is a [Protocol::HTTP::Response](https://github.com/socketry/protocol-http/blob/main/lib/protocol/http/response.rb)

## Advanced

### Creating Events

> [!NOTE]
> Creating events is completely optional.

Milestone events for the main flows are created for you and you can just listen to them. However you may want to create your own:

```ruby
class MyEvent < LowEvent
  attr_reader :my_data

  def initialize(my_data:, action: :my_action)
    super(key: self.class, action:)

    @my_data = my_data
  end
end
```

*Breakdown:*
- `action:` - The name of the method that you would like to call on the observer
- `key:` - The actual value to observe, which can be the class itself like `MyEvent` or any value such as a String
- `@my_data` - Any data you want to store as an attribute or multiple attributes

Trigger the event's action on its observers with:
```ruby
MyEvent.trigger(my_data: "Custom Data")
```

## Architecture

### Event-Command Hybrid

Raindeer events are different to traditional events in [event-driven architectures](https://en.wikipedia.org/wiki/Event-driven_architecture); they represent something that is currently happening, not something that has already happened.

|                  | **Event**     | **LowEvent**          | **Command** |
|------------------|---------------|-----------------------|-------------|
| **Tense**        | *Past*        | *Past/Present/Future* | *Future*    |
| **Naming**       | OrderCreated  | OrderEvent            | CreateOrder |
| **Action**       | 🚫            | `:create_order`       | ✅          |
| **Mutability**   | Immutable     | Mutable/Immutable     | Immutable   |
| **State**        | 🚫            | Ordered Actions       | 🚫          |
| **Broadcasting** | One to many   | Ordered one to many   | One to one  |
| **Return**       | 🚫            | Value or nil          | Value       |

### Event Tree

Because events represent a period of time they will have sub-events, resulting in a tree-like structure of parent and child events:

<img src="/assets/event-tree.svg" alt="Event Tree"/>

This structure can be used in debugging for enhanced observability. In the future this information will be shown in the `/system` UI, detailing who triggered and who responded to an event.

### Problems VS Solutions

Event-driven and distributed systems can suffer from a "who did what" problem. Raindeer mitigates each of these pain points:

| **Problem**                 | **Solution**                                                      |
|-----------------------------|------------------------------------------------------------------ |
| Implicit/hidden wiring      | Explicit `observe`/`observers <<`                                 |
| Unpredictible ordering      | Ordered and one-directional flow                                  |
| Unpredictible effects       | `trigger` and `take` [action types](/docs/observers#action-types) |
| Testing side effects        | Observers must be added per test                                  |
| Discoverability             | System UI lists events/routes/observers                           |
| Debugging and Logging       | Events are pipelines and tracked via UI                           |


## Unit Testing

Events must be manually observed in the test if you want to trigger observers.
