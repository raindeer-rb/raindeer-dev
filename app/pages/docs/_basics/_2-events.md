---
title: Events
---

Raindeer is an event-driven framework that represents the Request-Response lifecycle as events. This makes it easy to latch on to any event as they happen and perform additional tasks.

> ℹ️ Raindeer is event-driven but your application doesn't have to be and can call code directly as usual. In fact, major events in Raindeer are [abstracted away](https://en.wikipedia.org/wiki/Aspect-oriented_programming) to such a degree that you won't even know events are there unless you interact with them.

## Event Lifecycle

1. `RequestEvent` - The [server](/docs/server) converts HTTP requests into request events
2. `RouteEvent` - The [router](/docs/routing) creates route events from request events
3. `RenderEvent` - A [node](/docs/nodes) observes a route event and renders a response
4. `ResponseEvent` - A response event is converted by LowLoop into a response to the client that made the request

## Usage

### Observing Events

Observe the event with:

```ruby
class MyNode < LowNode
  observe MyEvent

  def render
    "My Response"
  end
end
```

### Creating Events (optional)

Create custom events with:

```ruby
class MyEvent < LowEvent
  attr_reader :my_data

  def initialize(my_data:, action: :my_action)
    super(key: self.class, action:)
    @my_data = my_data
  end
end
```

**Breaking it down:**
- `:my_action` - The name of the method that you would like to call on the observer
- `key: self.class` - The actual value to observe, which can be the class itself like `MyEvent` or any value such as a String
- `my_data` - Any data you want to store as an attribute or multiple attributes

Trigger the event's action on its observers with:
```ruby
MyEvent.trigger(data: "Custom Data")
```

## Architecture

### Event-Command Hybrid

Raindeer events are different to traditional events in [event-driven architectures](https://en.wikipedia.org/wiki/Event-driven_architecture). They represent as it is happening in the present-tense, not an event that has already happened.

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

<p align="center"><img src="assets/docs/Event Tree.svg" alt="Event Tree" height="400"/></p>

This structure can be used in debugging for enhanced observability.

## API

