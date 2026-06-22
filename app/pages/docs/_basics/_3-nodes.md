---
title: Nodes
---

Nodes are the flexible building blocks of your application. They can respond to a route request, or they can be called by another node. They can render a return value, or they can create an event. They are designed to be specific enough to observe events and return values, but generic enough to be split up to represent a complex application with its own patterns and structure.

Nodes can render HTML/JSON directly from the Ruby class (via RBX, similar to JSX) and render other nodes into the output using [Antlers](https://github.com/raindeer-rb/antlers) syntax; `<html><{ ChildNode }></html>`.

## Observing

After setting up a route, `observe` it to render a response:

```ruby
class HomeNode < LowNode
  observe '/'

  def render
    "The '/' route event called this render action/method"
  end
end
```

## Rendering

### Implicit syntax

The `observe 'path'` syntax is the simplest way to respond to a route. Either `render` or `receive` method [UNRELEASED] will be called by the `RouteEvent`'s action of the same name, depending on which HTTP request was received and which routes have been defined in the router.

- The `render` method will be called for `GET` and `QUERY` HTTP requests
- The `receive` method will be called for the  `POST`, `DELETE` and `PUT` HTTP requests.

The actions are split up this way so that you can have both actions/methods in the same file.

### Explicit syntax [UNRELEASED]

For more flexibility use the `observe Route['path']` syntax.

A `Route['path']` event is triggered for HTTP request, with the HTTP verb becoming the corresponding event action:
- GET 'path' => `observe Route['path'], :get`
- POST 'path' => `observe Route['path'], :post`
- QUERY 'path' => `observe Route['path'], :query`
- DELETE 'path' => `observe Route['path'], :delete`
- PUT 'path' => `observe Route['path'], :put`

For example, a GET request to the `'/'` path will call the `get` method and look like this:
```ruby
class HomeNode < LowNode
  observe Route['/'], :get

  def get
    "Response"
  end
end
```

## Output types

### RBX

Use `.rbx` as your file extension and now you can place HTML inside of `render()`:

```ruby
class MyNode < LowNode
  def render
    <p>Hello</p>
  end
end
```

### Antlers

Antlers syntax can be embedded within RBX:
```ruby
class ParentNode < LowNode
  def render
    <html><{ ChildNode }></html>
  end
end

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
> All arguments are omittable

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
    <strong>{my_var}</strong> # => '<strong>Yes</strong>'
  end
end
```

## Unit Testing

Nodes use the **Method Factory** pattern. Instead of calling `new` directly, you first call a class method which instantiates and sets up the class on your behalf, then calls the corresponding instance method.

Say your class looks like this:
```ruby
class ListNode < LowNode
  def render
    <ul>...</ul>
  end
end
```

To test the `render` instance method call the `render` class method:
```ruby
RSpec.describe ListNode do
  describe '#render' do
    it 'renders a list' do
      expect(subject.render).to eq('<ul>...</ul>')
    end
  end
end
```

The `render` class method will instantiate the class then call the `render` instance method.
