---
title: Events
published: true
---

<{ :toc }>

Raindeer is an event-driven framework that represents the Request-Response lifecycle as events. It's easy to latch on to any event as they happen and perform additional tasks.

> ![note]
> Raindeer is event-driven internally but your application doesn't have to be. In fact, Raindeer's main events are [abstracted away](/docs/architecture#aspect-orientated-programming) to such a degree that you can ignore them.

## Event Lifecycle

1. [RequestEvent](/docs/events#requestevent) - The server converts HTTP requests into request events
2. `RouteEvent` - The [router](/docs/routing) creates route events from request events
3. `RenderEvent` - A [node](/docs/nodes) observes a route event and renders a response
4. `ResponseEvent` - A response event is converted by LowLoop into a response to the client that made the request

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

The `RequestEvent` contains a [request](https://github.com/socketry/protocol-http/blob/main/lib/protocol/http/request.rb), which is a `Protocol::HTTP::Request` provided by [Protocol::HTTP](https://socketry.github.io/protocol-http/).

## Advanced

### Creating Events

> [!info]
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
MyEvent.trigger(data: "Custom Data")
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

This structure can be used in debugging for enhanced observability.
