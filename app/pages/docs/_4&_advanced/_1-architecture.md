---
title: Architecture
published: true
---

<{ :toc }>

<img src="/assets/architecture.svg" alt="Raindeer Architecture"/>

<hr />

## Design Patterns

### Event-driven

Raindeer is event-driven, but as much as possible [events](/docs/events) are created and triggered by the framework itself, hiding the complexity of traditional event-driven applications in order to make the framework easier to use.

### Asynchronous

Raindeer responds to requests asynchronously via Fibers. This improves performance and concurrency on IO-bound workloads like getting data from a database. This also means that you need to block the current Fiber when [debugging](/docs/debugging).

### Parallelism

While the handling of thousands of requests is asynchronous, each individual request can have its workload parallelised. Inside each [LowNode](/docs/nodes#parallelism) are various tools to achieve parallelism.

### Pipelines

[Pipelines](https://en.wikipedia.org/wiki/Pipeline_(software)) are one of the simplest and easiest patterns to understand. What's not to love about a linear series of events? In Raindeer **everything's a pipeline**:

- [Events](/docs/events) - Ordered observers and ordered event tree
- [Pipelines](/docs/pipelines) - Even the pipelines are pipelines!

### Composition

- [Nodes](/docs/nodes) have:
  - Different behaviours depending on the `render`, `receive` methods defined
  - Nest inside each other via `<{ ChildNode }>` [component syntax](/docs/templating#components)
- [Data Expressions](/docs/data#data-expressions) join tables together using `A[:one] + B[:two]` syntax

### Aspect-orientated programming

[Abstract-orientated programming](https://en.wikipedia.org/wiki/Aspect-oriented_programming) is larger in scope than what Raindeer makes use of. Primarily Raindeer uses AOP in the sense that *internally* there are "filters" that run before [milestone events](/docs/events#event-lifecycle), creating and triggering events on your behalf.

## Namespaces

- `Low` - Internal namespace for Low components (which can be used standalone)
- `Rain` - Internal namespace for Raindeer components
- `Raindeer` - External class for accessing the Raindeer API
- `Providers` - External class for accessing dependencies

For example, when you call `Raindeer.router` it calls `Providers['rain.router']` and this dependency is an instance of `Rain::Router`.

**In summary:**
- `Raindeer` is the public facing namespace.  
- Low components such as `LowType` or `LowNode` are accessed without a namespace.

## Philosophy

### 🪆 Composition over convention

Methods and classes should be *compositional*, so that you can understand their hidden complexity by drilling down into them as they go, rather than calling one magic method that does a bunch of side quests. APIs should be less magical and more compositional.

A perfect example is the `has_many` helper method provided by various ORMs. This method adds "association" methods to a model, then hides the fact that databases do joins on tables. You will have to do a `JOIN` on a table eventually, so it's better to represent tables as being merged together from the start. There has to be a more compositional way that exposes the database structure while letting you query that structure easily. Raindeer uses [Data Expressions](/docs/data#data-expressions) to represent table structure compositionally:

```ruby
class PostsData < LowData
  def all
    Users[:username] + Posts[:title, :body]
  end
end
```

ℹ️ This data expression generates SQL to `OUTER JOIN` the user table with the posts table and results in a list of posts with the user's username included in each row.
