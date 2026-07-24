---
title: Architecture
section: advanced
---

<{ :toc }>

## Event-driven

Raindeer is event-driven, but as much as possible these events are created and triggered by the framework itself, hiding the complexity of traditional event-driven applications in order to make the framework easier to use. See ["Aspect-orientated programming"](aspect-orientated-programming).

## Asynchronous

Raindeer responds to requests asynchronously via Fibers. This means that you need to block the current Fiber when [debugging](/docs/debugging).

## Composition

## Aspect-orientated programming

[Abstract-orientated programming](https://en.wikipedia.org/wiki/Aspect-oriented_programming) is larger in scope than what Raindeer makes use of. Primarily Raindeer uses AOP in the sense that *internally* there are "filters" that run before important milestone `Event`s are created and triggered. This distinction between internal and external framework APIs is important to make. To the framework user (developer) and the application that builds upon it, hooks are exposed as events as much as possible.

Internal "pre-filters" happen at the following stages:
- `LowNode` - The class `render` instantiating the object and calling the instance's `render` method is the *Method Factory* pattern and is essentially a pre-filter

## Namespaces

- `Low` - Internal namespace for Low components (which are somewhat stand-alone)
- `Rain` - Internal namespace for Raindeer components
- `Raindeer` - External namespace for accessing the Raindeer API
- `Providers` - External namespace for accessing dependencies, often used by the `Raindeer` namespace internally but can also be accessed directly

> **Example:**
> `Raindeer.router` actually just calls `Providers['rain.router']` and this dependency is an instance of `Rain::Router`

**In summary:**
`Raindeer` is the public facing namespace.  
Low components such as `LowType` or `LowNode` are accessed without a namespace.
