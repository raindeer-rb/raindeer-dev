---
title: Testing
---

Run all tests with `bundle exec rspec`.
Add the `SHOW_OUTPUT=1` flag to see the terminal output of some of the feature tests.

## Unit Testing

Each component details how they should be unit tested:
- [Nodes](/docs/nodes#unit-testing)

## Feature Testing

### Events

Nodes can be triggered and rendered via events. Most of the time the `observe` method is a class-level method which calls class-level methods on the observer. This fits in perfectly with the Method Factory pattern shown above, where a class level method instanitates the class and calls the corresponding instance method of the same name.

To test an event triggering an action on an observer do:
```ruby
...
```

### Requests

To test the full application lifecycle then we will actually need to send an HTTP request to a mock server.
