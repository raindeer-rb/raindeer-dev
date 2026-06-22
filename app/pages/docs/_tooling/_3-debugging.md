---
title: Debugging
---

Raindeer is an asynchronous framework where many things/tasks (Fibers) are happening at once. This can make debugging a little harder if you don't know what you're doing, as code can error and the application can move on to the next task before you're finished reading the error and trying to debug it.

### Debug Mode

Set `RAIN_DEBUG=1` to block the current asynchronous fiber and show the backtrace when an exception is raised.

ℹ️ This will make your development experience much better.

### Asynchronous Mode

`RAIN_ASYNC_MODE=1` is the default. In this async environment we must first block the fiber:
```ruby
Fiber.blocking { binding.irb }
```

https://socketry.github.io/async/guides/debugging/index

### Synchronous Mode

Set `RAIN_ASYNC_MODE=0` to run the server synchronously, making normal debugging techniques easy:
```ruby
p variable
puts variable
binding.pry # Debug mode requires pry for you
```
