---
title: Nodes
published: true
---

<{ :toc }>

Nodes are the flexible building blocks of your application. They can respond to a route request, or they can be called by another node. They can render a return value, or they can create an event. They are designed to be specific enough to observe events and return values, but generic enough to be split up to represent a complex application with its own patterns and structure.

Nodes can render HTML/JSON directly from the Ruby class (via RBX, similar to JSX) and render other nodes into the output using the [syntax](/docs/templating#components); `<html><{ ChildNode }></html>`.

## Observing

After setting up a route, `observe` it to render a response:

```ruby
class HomeNode < LowNode
  observe '/'

  def render(event: RequestEvent)
    # event.request.path => '/'
  end
end
```

> ![note]
> [Events](/docs/events) can call different actions/methods

### Implicit syntax

The `observe 'path'` syntax is the simplest way to respond to a route. Either the `render` or `receive` method [UNRELEASED] will be called by the `RouteEvent`'s action, depending on which HTTP request was received and which routes have been defined in the router.

- The `render` method will be called for `GET` and `QUERY` HTTP requests
- The `receive` method will be called for the  `POST`, `DELETE` and `PUT` HTTP requests.

The actions are split up this way so that you can have both actions/methods in the same file, and... it just feels right™... to send and receive. To be, or not to be, that is the question: Whether 'tis nobler in the mind to suffer the slings and arrows of outrageous fortune, or to take arms against a sea of troubles.

### Explicit syntax [UNRELEASED]

For all you HTTP nerds, you can have more flexibility with the `observe Route[HTTP_VERB => 'path']` syntax.

A `RouteEvent` is triggered for the HTTP request where the HTTP verb becomes the corresponding event action:
- **GET:** `observe Route[GET => 'path']`
- **POST:** `observe Route[POST => 'path']`
- **QUERY:** `observe Route[QUERY => 'path']`
- **DELETE:** `observe Route[DELETE => 'path']`
- **PUT:** `observe Route[PUT => 'path']`

For example, a GET request to the `'/'` path will call the `get` method and look like this:
```ruby
class HomeNode < LowNode
  observe Route[GET => '/']

  def get(event: RequestEvent)
    "Response"
  end
end
```

And this looks really good too with the ["on" syntax](/docs/events#on-syntax):
```ruby
on Route[GET => '/'] do |request_event|
  "Response"
end
```

> ![note]
> If no method matches the event's action then nothing happens, the observer returns `nil`. You get nothing! You lose! Good day, sir! You stole Fizzy Lifting Drinks! You bumped into the ceiling which now has to be washed and sterilized. Raindeer will move on to the next observer.

## Responding

### `nil`

If the method

### String

```ruby
class MyNode < LowNode
  def render
    "Hello"
  end
end
```

### HTML

```ruby
class MyNode < LowNode
  def render
    <html>{"Yes this is fine."}</html>
  end
end
```

### JSON

`Hash` return values are converted to a JSON string.

```ruby
class MyNode < LowNode
  def render
    {
      error: "This framework is too awesome, burns my eyes."
    }
  end
end
```

## File types

### Ruby

Use `.rb` and you can `render` strings and hashes (which get converted to JSON):

```ruby
class MyNode < LowNode
  def render
    "Hello"
  end
end
```

### RBX

Use `.rbx` as your file extension and now you can place HTML inside of `render`:

```ruby
class MyNode < LowNode
  def render
    <p>Hello</p>
  end
end
```

### Antlers

Antlers + RBX can be used to render nodes within nodes:
```ruby
class ParentNode < LowNode
  def render
    <html><{ ChildNode }></html>
  end
end
```

```ruby
class ChildNode < LowNode
  def render
    <strong>Hello</strong>
  end
end
```

Which outputs:
```HTML
<html><strong>Hello</strong></html>
```

**See also:** [Antlers](https://github.com/raindeer-rb/antlers) source and syntax guide

## Arguments

> [!note]
> All methods called via events have omittable arguments 

An `event` keyword argument is always available to all `initialize` and `render` arguments.

```ruby
class MyNode < LowNode
  def render(event:)
    "Event contains the HTTP request, URL parameters and more..."
  end
end
```

If the node has been rendered by another node then any props passed to that node are available as keyword arguments in the node's `initialize` or `render` methods.

**Passing props:**
```ruby
<{ MyNode my_var='Yes' }>
```

**Receiving args:**
```ruby
class MyNode < LowNode
  def render(my_var:)
    <strong>{my_var}</strong>
  end
end
```

**Outputs:**
```html
<strong>Yes</strong>
```

## Parallelism [UNRELEASED]

```ruby
def render
  <{ parallelize: }>
    # For Loop executed at the same time as UserNode.
    <{ for: user in: @users }>
      <{ UserNode user=user }>
    <{ :for }>

    # PostsNode executed at the same time as For Loop.
    <{ PostsNode }>
  <{ :parallelize }>
end
```

## Unit Testing

> ![note]
> Nodes use the **Method Factory** pattern. You call the *class* method to call the *instance* method.

Instead of calling `new` on a node class directly, first you call a class method which instantiates the class on your behalf, then calls the corresponding instance method.

Say your class looks like this:
```ruby
class ListNode < LowNode
  def render
    <ul>...</ul>
  end
end
```

To call the `#render` *instance* method you first call the `.render` *class* method:
```ruby
RSpec.describe ListNode do
  describe '#render' do
    it 'renders a list' do
      expect(subject.render).to eq('<ul>...</ul>')
    end
  end
end
```
