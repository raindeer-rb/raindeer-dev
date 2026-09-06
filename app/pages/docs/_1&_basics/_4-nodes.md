---
title: Nodes
published: true
---

<{ :toc }>

Nodes are the flexible building blocks of your application. They can respond to a route request, or they can be called by another node. They can render a return value, or they can create an event. They are designed to be specific enough to observe events and return values, but generic enough to be split up to represent a complex application with its own patterns and structure.

Nodes can render HTML/JSON directly from the Ruby class (via RBX, similar to JSX) and render other nodes into the output using the [syntax](/docs/templating#components); `<html><{ ChildNode }></html>`.

## Observing routes

After setting up a [route](/docs/routing), `observe` it to render a response:

```ruby
class UserNode < LowNode
  observe '/:user_id'

  def render(event: RenderEvent)
    event.params[:user_id] # => '123'
  end
end
```

> [!NOTE]
> [Events](/docs/events) decide which actions are called. [Observers](/docs/observers) decide which actions are accepted.

### Implicit syntax

The `observe '/path'` syntax is the simplest way to respond to a request. It observes a route and calls the `render` method... or the `receive` method if a body was sent in the original request. Constrain the HTTP Verbs via the [route type](/docs/routing#route-types).

The actions are split up this way so that you can have both receiving and responding methods in the same file, and... it just feels right™... to send and receive. To be, or not to be, that is the question: Whether 'tis nobler in the mind to suffer the slings and arrows of outrageous fortune, or to take arms against a sea of troubles.

For all you HTTP nerds, you can have more flexibility with the syntax:
```ruby
observe '/path' => :action
```

The HTTP request/verb becomes the corresponding event/action:
| **HTTP Verb** | **Event**      | **Action** |
|---------------|----------------|------------|
| `GET`         | `RenderEvent`  | `get`      |
| `QUERY`       | `ReceiveEvent` | `query`    |
| `POST`        | `ReceiveEvent` | `post`     |
| `PUT`         | `ReceiveEvent` | `put`      |
| `PATCH`       | `ReceiveEvent` | `patch`    |
| `DELETE`      | `RenderEvent`  | `delete`   |

> [!TIP]
> A `ReceiveEvent` is just like a `RenderEvent` except it also has a `body` attribute.

For example, a `POST` request to the `'/feedback'` route will call the `post` action/method:
```ruby
class FormNode < LowNode
  observe '/feedback' => :post

  def post(event: ReceiveEvent)
    submit(event.body)
    Status[200]
  end
end
```

### Explicit syntax [CANDIDATE]

An alternate syntax is to observe the `Route` that was created via the router:
```ruby
observe Route[POST => '/feedback']
```

Since we're observing a `POST` route then the event's action will always be `:post`, but you can leave it in for clarity:

```ruby
observe Route[POST => '/feedback'] => :post
```

> [!NOTE]
> If no method matches the event's action then nothing happens, the observer returns `nil`. You get nothing! You lose! Good day, sir! You stole Fizzy Lifting Drinks! You bumped into the ceiling which now has to be washed and sterilized. Raindeer will move on to the next observer.

**See also:** [Observers](/docs/observers)

## Responding

> [!CAUTION]
> **TODO:** I built a whole framework and missed something important. The `RenderEvent` needs to have the `params` from `RouteEvent` brought over to it... Whoops.

Every node supports an `initialize` and a `render` method. The class is initialized first before then being rendered. You can access any instance variables or methods from the `render` method:

```ruby
class UserNode < LowNode
  observe '/:id'

  # Business logic.
  def initialize(event: RouteEvent)
    @id = event.params[:id]
  end

  # Templating.
  def render
    <strong>ID:</strong> {@id}
  end
end
```

### Inline Syntax [CANDIDATE]

Don't need to separate business logic from rendering logic? Do it all in `render`:

> [!WARNING]
> This feature is in consideration and may not ever be implemented, as separating logic from the template is a good thing.

```ruby
class UserNode < LowNode
  observe '/:id'

  def render(event: RenderEvent)
    id = event.params[:id]

    <strong>ID:</strong> {id}
  end
end
```

## Observing + Responding

With the ["on" syntax](/docs/events#on-syntax) we can observe and respond in one fell swoop:
```ruby
on Route[GET => '/'] do |request_event|
  "Response"
end
```

## Return Types

### Empty

As hinted to by the elaborate note above, if our node method returns `nil` or `''` and there are no other observers then the [router](/docs/routing) will default to a 404 response.

```ruby
class MyNode < LowNode
  def render
    nil
  end
end
```

### String

```ruby
class MyNode < LowNode
  def render
    "Hello"
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

### RBX

RBX is just HTML inside Ruby. Use `.rbx` as your file extension and now you can place HTML inside of `render`:

```ruby
class MyNode < LowNode
  def render
    <strong>Hello</strong>
  end
end
```

### RBX + Antlers

Antlers allows you to render nodes within nodes:
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

**See also:** [Templating](/docs/templating#components)

## Calling other code

Nodes are designed for intercepting the request-response layer and then handing off control to your domain-specific models, presenters and business logic.

### Calling a class

All classes in `/app` are autoloaded so you can call any class from any node:
```ruby
# /app/business_directory/business_logic.rb
class BusinessLogic
  def self.metrics(company_id:)
    # Calculate a bunch of business metrics.
  end
end

# /app/business_directory/business_directory.rbx
class BusinessDirectory < LowNode
  observe '/:company_id'

  def initialize(event: RouteEvent)
    company_id = event.params[:company_id]
    @metrics = BusinessLogic.metrics(company_id:)
  end

  def render
    <{ Metrics metrics=@metrics }>
  end
end
```

### Injecting a dependency

See: [Dependencies](/docs/dependencies)

## Arguments

> [!note]
> All methods called via events have an omittable `event:` argument

### Route level args

An `event` keyword argument is optionally available to all `initialize` and `render` arguments.

```ruby
class UserNode < LowNode
  observe '/:user_id'

  def initialize(event: RouteEvent)
    event.request.path # => '/123'
    event.params[:user_id] # => '123'
  end

  def render(event: RenderEvent)
    event.request.path # => '/123'
    event.params[:user_id] # => '123'
  end
end
```

### Render level args

If the node has been rendered by another node then any [props](/docs/templating#props) passed to that node are available as keyword arguments in the node's `initialize` or `render` methods. The `event:` arg to `initialize` is now a `RenderEvent` and not a `RouteEvent` in this situation.

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

Speed up CPU-bound work with parallelism. Thanks to the immutable nature of nodes we can process them in parallel using the `<{ parallelize: }>` syntax. Your data must be immutable or be able to be copied by Raindeer. This means reducing your reliance on global state, such as global dependency injection via [Providers](/docs/dependencies#providers), in favour of local dependency injection via [Plugs](/docs/dependencies#plugs).

> [!NOTE]
> IO-bound work like database queries are essentially parallel already, as multiple asynchronous requests will simultaneously wait for database results. However the CPU-bound processing of these results is not parallelized, so you'll still see a speed up... depending on what you're doing.

### Siblings

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

### Children

```ruby
def render
  # Each item in the loop is executed at the same time.
  <{ for: user in: @users :parallelize }>
    <{ UserNode user=user }>
  <{ :for }>
end
```

## Replicating CRUD

CRUD (Create, Read, Update, Delete) is pretty standard in web applications. Raindeer replaces controllers and actions with events and actions. Instead of a central controller for disparate create, read, update and delete actions, you observe the appropriate route (`/user/new`, `/user/delete`) with a standalone node for each event/action that happens to that route.

At first this may seem like more boilerplate for each action... but consider that in a controller each action usually becomes bloated over time, with either fat controllers or fat models. This way you are forced to focus on "single-responsiblity" from the start. Over time your `UserUpdater` or `UserDeleter` node will be able to handle increasingly complexity gracefully. Additionally, you are now freed from the constraints of CRUD.

> [!TIP]
> In Raindeer the node is the controller, the service object and the template all-in-one.

### Single Responsibility

**Route:**
```ruby
Raindeer.router do
  route PUT => '/:user_id/update'
end
```

**Node:**
```ruby
class UserUpdater < LowNode
  observe '/:user_id/update'

  def receive(event: ReceiveEvent)
    update(user_id: event.params[:user_id], event.body[:attributes])
    
    Status[200]
  end

  private

  def update(user_id:, attributes:)
    DB[:users].where(id: user_id).update(**attributes)
  end
end
```

### Classic Controller

Okay... since you were going to do it anyway, here's how to replicate a controller one-to-one in Raindeer.

**Route:**
```ruby
Raindeer.router do
  route [GET, POST, PUT, DELETE] => '/:user_id'
end
```

**Node:**
```ruby
class UserController < LowNode
  observe '/:user_id'

  def get(event: RenderEvent)
    find(user_id: event.params[:user_id])
    UserNode.render(event:, user_id:)
  end

  def post(event: ReceiveEvent)
    create(user_id: event.params[:user_id], event.body[:attributes])  
    Status[200]
  end

  def put(event: ReceiveEvent)
    update(user_id: event.params[:user_id], event.body[:attributes])  
    Status[200]
  end

  def delete(event: RenderEvent)
    delete(user_id: event.params[:user_id])
    Status[200]
  end

  private

  def update(user_id:, attributes:)
    DB[:users].where(id: user_id).update(**attributes)
  end

  # Etc.
end
```

## Unit Testing

> [!NOTE]
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
