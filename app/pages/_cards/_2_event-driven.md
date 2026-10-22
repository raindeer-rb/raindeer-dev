---
title: Event-driven
title_link: /docs/events
summary: Observe and respond to events
---

```ruby
observe '/:id'

def render(event: RenderEvent)
  event.params[:id] # => 123
end
```
