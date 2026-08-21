---
title: Debugging
published: true
---

<{ :toc }>

Raindeer is an asynchronous framework where many things/tasks (Fibers) are happening at once. This can make debugging a little harder if you don't know what you're doing, as code can error and the application can move on to the next task before you're finished reading the error and trying to debug it.

### Debug Mode

In development Raindeer will automatically block the current asynchronous fiber and show the backtrace when an exception is raised.

Set `RAIN_DEBUG=1` to `RAIN_DEBUG=0` in production so that broken fibers don't block others.

### Asynchronous Mode

`RAIN_ASYNC=1` is the default. In this async environment we must first block the fiber:
```ruby
Fiber.blocking { binding.irb }
```

**See also:** https://socketry.github.io/async/guides/debugging/index

### Synchronous Mode

Set `RAIN_ASYNC=0` to run the server synchronously, making familiar non-blocking debugging techniques easy such as:
```ruby
p variable
puts variable
binding.pry
binding.irb
```
