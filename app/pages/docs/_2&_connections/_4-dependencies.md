---
title: Dependencies
published: true
---

<{ :toc }>

Dependencies are "things your application needs". When you call a method with an argument then you are supplying a dependency. Raindeer provides 2 main ways to manage dependencies; Providers for global dependencies and Plugs for local dependencies.

> [!NOTE]
> This page is a work in progress. Dependencies in an event-driven, compositional and potentially parallel environment is still being figured out.

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

See: https://github.com/raindeer-rb/providers#injectors

## Plugs

Plugs are "local" dependencies, for managing the code itself inside your classes.

See: https://github.com/raindeer-rb/plugs
