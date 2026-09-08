---
title: Dependencies
published: true
---

<{ :toc }>

Dependencies are "things your application needs". When you call a method with an argument then you are supplying a dependency. Raindeer provides 2 main ways to manage dependencies; Providers for global dependencies and Plugs for local dependencies.

## Providers

Providers are "global" dependencies that can be setup once at boot time and injected anywhere; such as a logger.

### Defining

Provide the dependency with:
```ruby
Providers.define(:logger) do
  Logger.new
end
```

Namespaced string keys are fine too:
```ruby
Providers.define('billing.payment_provider') do
  PaymentProvider.new
end
```

Eager load a provider by adding an `eager: true` keyword argument:
```ruby
Providers.define(:logger, eager: true) do
  Logger.new # Initialised immediately, not when the dependency is requested.
end
```

### Injecting

> [!WARNING]
> Work in progress. These APIs will have bugs, which you're welcome to submit a PR for.

#### Providers Hash

```ruby
logger = Providers[:my_provider]
```

As a default argument (leave off the argument when initialising):

```ruby
class MyClass
  def initialize(logger: Providers[:my_provider])
    @logger = logger # => "logger" is injected.
  end
end
```

#### Dependency Expressions

> [!WARNING]
> Dependency Expressions require [types](/docs/types) to be enabled.

Place a `Dependency` expression as the default value of your dependency:

```ruby
class MyClass
  def initialize(logger: Dependency)
    @logger = logger # => "logger" is injected.
  end
end
```

To define a provider with a different name to that of the local variable do:
```ruby
def initialize(dependency_one: Dependency | :provider_one)
  dependency_one # => Dependency injected from :provider_one.
end
```

#### Constructor Include

Or you may like to use the more traditional `include` syntax:

```ruby
class MyClass
  include Dependencies[:logger]

  def my_method
    @logger # => "@logger" is injected.
  end
end
```

This method hides and creates the constructor on your behalf.

## Plugs

> [!TIP]
> Plugs will also be the way to use dependencies inside Ractors in future. It needs just a bit more work to be thread-safe.

Plugs are "local" dependencies, defined globally but can be instantiated anywhere. Each time you call `Plug[]` it insantiates a new object, so you can use them inside parallelized code and move them around from method to method.

### Defining plugs

```ruby
class MyPlugs
  include Plugs

  plug(:html) do
    plug(:node) do
      require_relative '../nodes/html_node'
      HTMLNode
    end
  end

  plug(:form) do
    plug(:lexeme) do
      require_relative '../lexemes/form_lexeme'
      FormLexeme
    end

    plug(:node) do
      require_relative '../nodes/form_node'
      FormNode
    end
  end
end
```

### Getting plugs

```ruby
# Get all "html" and "form" plugs and their children.
def new(plugs: MyPlugs[:html, :form])
  plugs.to_a # => [HTMLNode, FormLexeme, FormNode].
end

# Get all "node" plugs regardless of their parent.
def new(plugs: MyPlugs[:node])
  plugs.to_a # => [HTMLNode, FormNode]
end
```

**See:** https://github.com/raindeer-rb/plugs
