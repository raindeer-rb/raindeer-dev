---
title: Data Expressions
title_link: /docs/data#data-expressions
summary: Build SQL queries compositionally
---

```ruby
Posts[:title, :body] + Users[:username]
```

Results in a list of posts with each post's user nested inside it.
