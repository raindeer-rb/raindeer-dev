---
title: Data Expressions
title_link: /docs/data#data-expressions
summary: Build SQL queries compositionally
---

```ruby
Users[:name] + Posts[:title, :body]
```

Results in an `OUTER JOIN` SQL query.
