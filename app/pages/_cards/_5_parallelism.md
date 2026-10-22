---
title: Parallelism
title_link: /docs/nodes#parallelism-unreleased
summary: Immutable nodes designed for parallel execution
---

```ruby
<{ parallelize: }>
  <{ UserNode user=@user }>
  <{ PostsNode posts=@posts }>
<{ :parallelize }>
```
