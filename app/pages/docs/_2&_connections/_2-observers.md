---
title: Observers
published: true
---

<{ :toc }>

Observers are decoupled from the [events](/docs/events) they observe. This is because we're not always observing events! We may be observing a route like `'/:id'` or `Route[':id']` or a status code like `Status[404]`, and we can trigger events for these objects too. Think of events as the building blocks/structure, and observers as the wiring/glue that connects them together.

[Nodes](/docs/nodes) include observers by default, but you can include them into any class:

```ruby
class MySubscriber
  include Observers
end
```

## Observing

### Subscriber to Publisher

```ruby
class MySubscriber
  include Observers
  observe MyPublisher

  def self.handle
    # This class method will be called upon trigger.
  end
end
```

### Publisher to Subscriber

Add observers *from* the object being observed with:
```ruby
class MyPublisher
  include Observers
  observers << MySubscriber
end
```

> [!TIP]
> Reference a publisher other than `self` with:
> ```ruby
> observers(OtherPublisher) << my_observer
> ```

## Ordering

Observers are ordered, called in the order that they are defined but can be reordered via an array-like interface. You can add observers on either side; from the object being observed or the observer. When ordering is important, add observers from the observed side.

> [!TIP]
> Observers should only be re-ordered once per observee so that you don't lose track.

### Event Observers

```ruby
MyEvent.define do |observers|
  observers # Access existing observers array.
  observers << MyObserver # Add an observer at the end.
  observers = [MyObserver, *observers] # Add an observer at the start.
end
```

### Object Observers [CANDIDATE]

For observing objects that aren't `Event` classes such as routes you can do:
```ruby
Observers['/:user_id' => :get].define |observers|
  observerse << my_observer
end
```

## Actions

> [!NOTE]
> Events define their own actions and observers **CANNOT** change the action. Events retain control over which actions are called. This allows for a predictable [one-directional](https://en.wikipedia.org/wiki/One_Direction) flow between events. Complex workflows can be reasoned about more easily without worrying that an observer somewhere is overriding every action on an event and executing unrelated behaviour and output.

Call the `my_action` method on all observers of `MyPublisher` with:
```ruby
class MyPublisher
  include Observers
  trigger action: :my_action
end
```

## Events

Trigger events on observers with the `event` keyword argument:
```ruby
class MyPublisher
  include Observers
  trigger event: MyEvent.new(my_data)
end
```

Events define their own actions, or you can override them when triggering:

```ruby
class MyPublisher
  include Observers
  trigger event: MyEvent.new(my_data), action: :my_action
end
```

ℹ️ All observers to `MyPublisher` will have their `my_action(event:)` method called with the event passed in as a keyword argument.

### With Keys

Call actions on all observers of a differeent object/key with a `key:` keyword argument:
```ruby
trigger key: OtherPublisher, action: :my_action
trigger key: OtherPublisher, action: :my_action
trigger key: OtherPublisher, action: :my_action, event: MyEvent.new(event_data)
```

#### Action Accepting [UNRELEASED]

In this example we're observing the route for all types of HTTP requests, but only accepting the `QUERY` HTTP verb as our action/method:
```ruby
observe Route['/:question'] => :query
```

#### Action Forwarding [UNRELEASED]

You can redirect an action to call a method of a different name:
```ruby
observe Route[QUERY => '/:question'] => { query: :answer }
```

This forwards the `query:` action to the `:answer` action/method.

## Action Types

- `trigger` - Calls all observers. Returns the last non-nil value.
- `take` - Calls all observers up until the first non-nil value. Returns the first non-nil value.
