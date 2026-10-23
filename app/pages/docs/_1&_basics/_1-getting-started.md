---
title: Getting Started
published: true
---

<article id="contributors">
  <header>
    <h2>Contributors</h2>
  </header>

  <ul>
    <li>
      <img class="icon" alt="" src="https://avatars.githubusercontent.com/u/601650"/>
      <strong class="username">maedi</strong>
    </li>
    <li>
      <img class="icon" alt="" src="https://avatars.githubusercontent.com/u/177754884"/>
      <strong class="username">Piyush-Goenka</strong>
    </li>
    <li>
      <img class="icon" alt="" src="https://avatars.githubusercontent.com/u/219598893?v=4"/>
      <strong class="username">obsidiannnn</strong>
    </li>
  </ul>

  <footer>
    <a href="/docs/contributing" role="button"><i class="bi bi-code-square"></i>Contribute</a>
  </footer>
</article>

**Create your application:**
```shell
gem install raindeer
rain new :app_name
```

Or clone the [template](https://github.com/raindeer-rb/raindeer-template).

**Then run the server:**
```shell
bundle install
rain server
```

**Visit:** http://127.0.0.1:4133/

You should see this page:



## Directory Structure

- `app` - Application files; routes, nodes, events and data
- `db` - Database migrations and seeds
- `bin` - Framework console scripts
- `config` - Boot and configuration files
- `public` - Assets such as images, CSS and JS files
- `spec` - Test the implementation of your application

## Database

Install gems and seed the database with:
```
bin/setup
```

`config/database.rb` connects to `db/development.sqlite3` and runs the migrations in `db/migrations` on boot. Set `DATABASE_URL` to use another database.

Repositories in `app/data` query the database with [LowData](https://github.com/low-rb/lowdata) data expressions:
```ruby
class PostsData < LowData
  def latest(count: 10)
    (Posts[:title, :body] + Users[:username]) ^ -Col[:created_at] * count
  end
end
```

Visit [http://127.0.0.1:4133/posts](http://127.0.0.1:4133/posts) to see them.

## Matrix Mode

After running the sever your terminal will output a matrix visualisation of the asynchronous events, giving you a feel for what is happening under the hood. For better performance you should disable this mode in production with the `RAIN_MATRIX=0` ENV variable.

**iTerm:** Press `Option + A` to accept screen refreshing, or output will bounce around.

## CLI

**See also:** [Rain CLI](/docs/cli)
