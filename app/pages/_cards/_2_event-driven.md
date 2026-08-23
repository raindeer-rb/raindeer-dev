---
title: Event-driven
title_icon: fire
summary: Observe and respond to events
---

```ruby
observe '/'

def render(event:)
  event.request.path # => '/'
end
```
