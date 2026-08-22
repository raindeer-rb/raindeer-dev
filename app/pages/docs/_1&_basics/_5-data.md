---
title: Data
published: true
---

<{ :toc }>

Raindeer uses the repository pattern, with `LowData` classes defining familiar methods such as `find`, `all`, `create` and `update`.

There are two main ways to query the database; traditional SQL queries and Data Expressions.

## SQL

Raindeer uses the [Sequel](https://sequel.jeremyevans.net/) gem for basic and advanced queries.

### Basic Query

```ruby
class PostsData < LowData
  def all
    DB[:posts].where(id: 1)
  end
end
```

`DB` is equivalent to `Sequel.sqlite` or your chosen database adapter.

## Data Expressions [UNRELEASED]

Instead of the model defining relationships and associated queries to the database, LowData follows the repository pattern with a twist; Data Expressions.

This expression joins the `posts` table with the `users` table while representing a join conceptually as simple arithmetic:

```ruby
class PostsData < LowData
  def all
    Users[:username] + Posts[:title, :body]
  end
end
```

The above expression generates SQL to join the user table with the posts table and results in a list of posts with the user's username included in each row.

### Inner Join

```ruby
Users[:username] & Posts[:title, :body]
```

### Outer Join

```ruby
Users[:username] + Posts[:title, :body]
```

### Left Join

```ruby
Users[:username] < Posts[:title, :body]
```

### Right Join

```ruby
Users[:username] > Posts[:title, :body]
```

## Data Inversion [UNRELEASED]

Data Expressions can invert the usual database query logic; instead of building a query of what we want from the database, we build the table we want and let the expression build the query.

```ruby
class PostsData < LowData
  def all
    Table[:username, :title, :body]
  end
end
```

This expression generates equivalent SQL to the `Users + Posts` example above. It's smart enough to know that we're in a `Posts` repository, and that our `Posts` table has a foreign key of `user_id` to the `Users` table. LowData then connects `:username` to this table automatically.

## Migrations

Use the Sequel gem to [manage migrations](https://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html).

## Integrations

LowData is probably the most flexible component of Raindeer, in that it can be completely swapped out for another library such as [Rom](https://hanakai.org/rom). You could even swap in ActiveRecord if you want, but you would make me cry 😢, do you want to make me cry?
