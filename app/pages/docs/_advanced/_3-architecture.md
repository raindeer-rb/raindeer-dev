---
title: Architecture
section: advanced
published: true
---

<{ :toc }>

## Event-driven

Raindeer is event-driven, but as much as possible [events](/docs/events) are created and triggered by the framework itself, hiding the complexity of traditional event-driven applications in order to make the framework easier to use.

## Pipelines

[Pipelines](https://en.wikipedia.org/wiki/Pipeline_(software)) are one of the simplest and easiest patterns to understand. What's not to love about a linear series of events? In Raindeer **everything's a pipeline**, even [Pipelines](/docs/pipelines) are pipelines.

## Asynchronous

Raindeer responds to requests asynchronously via Fibers. This improves performance and concurrency on IO-bound workloads like getting data from a database. This also means that you need to block the current Fiber when [debugging](/docs/debugging).

## Parallelism

While the handling of thousands of requests is asynchronous, each individual request can have its workload parallelised. Inside each [LowNode](/docs/nodes#parallelism) are various tools to achieve parallelism.

## Compositional

[LowNode](/docs/nodes)'s can be nested inside each other via Antlers `<{ ChildNode }>` syntax.

## Aspect-orientated programming

[Abstract-orientated programming](https://en.wikipedia.org/wiki/Aspect-oriented_programming) is larger in scope than what Raindeer makes use of. Primarily Raindeer uses AOP in the sense that *internally* there are "filters" that run before [milestone events](/docs/events#event-lifecycle) are created and triggered. This distinction between internal and external framework APIs is important to make. To the framework user (developer) and the application that builds upon it, hooks are exposed as events as much as possible.

Internal "pre-filters" happen at the following stages:
- `LowNode` - The class-level `.render` method instantiates the object and calls that object's `#render` method. This is the *Method Factory* pattern and is essentially a pre-filter

## Namespaces

- `Low` - Internal namespace for Low components (which are standalone)
- `Rain` - Internal namespace for Raindeer components
- `Raindeer` - External namespace for accessing the Raindeer API
- `Providers` - External namespace for accessing dependencies, often used by the `Raindeer` namespace internally but can also be accessed directly

For example; `Raindeer.router` calls `Providers['rain.router']` and this dependency is an instance of `Rain::Router`.

**In summary:**
- `Raindeer` is the public facing namespace.  
- Low components such as `LowType` or `LowNode` are accessed without a namespace.

## Philosophy

### `.[]` Syntax

Raindeer uses the `[]` class syntax a lot, but it does so within reason. Our guiding rule is:

> The `[]` syntax should access collections, not call constructors or methods.

While it's tempting to use this syntax as a "constuctor" for modules (`MyModule[config:]`), it's actually counter productive, it muddies the waters. Users should see `[]` and instantly know that they're accessing or definining a collection of objects, not constructing or returning a single object. Just use `.new()` or call a named method.
