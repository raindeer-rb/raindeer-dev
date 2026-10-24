---
title: Benchmarks
published: true
---

<{ :toc }>

## CPU-bound

### 1000 routes

**Configuration:**
- 1 thread/fiber
- 1000 routes in one route table, nested like real REST resources (`/solo5`, `/solo5/duo5`, `/solo5/duo5/trio2`)
- Each column requests a route at that path depth (`/solo200`, `/solo5/duo15`, `/solo5/duo5/trio2`)
- Sinatra and Roda check routes one by one in the order they're declared, so their speed depends on where a route sits in the list. Each requested route is the middle one of its group, a typical case rather than the best or worst

> [!NOTE]
> **Requests Per Second:** This CPU-bound metric is a relatively small slice of time in comparison to the typical IO-bound tasks of web applications, such as waiting for the database.

<table>
  <thead>
    <tr>
      <th>Server</th>
      <th>GET / (req/s)</th>
      <th>1 segment (req/s)</th>
      <th>2 segments (req/s)</th>
      <th>3 segments (req/s)</th>
      <th>Mean latency (3 segments)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Roda</strong> + Falcon</td>
      <td>7,948.17</td>
      <td>3,038.29</td>
      <td>7,006.14</td>
      <td>7,220.58</td>
      <td>6.925 ms</td>
    </tr>
    <tr>
      <td><strong>Raindeer</strong> + LowLoop</td>
      <td>4,927.88</td>
      <td>3,905.35</td>
      <td>3,510.91</td>
      <td>3,551.81</td>
      <td>14.077 ms</td>
    </tr>
    <tr>
      <td><strong>Raindeer</strong> + Falcon</td>
      <td>5,228.65</td>
      <td>3,606.68</td>
      <td>3,333.89</td>
      <td>3,148.49</td>
      <td>15.881 ms</td>
    </tr>
    <tr>
      <td><strong>Hanami</strong> + Falcon</td>
      <td>1,845.39</td>
      <td>1,906.14</td>
      <td>1,960.15</td>
      <td>1,956.06</td>
      <td>25.562 ms</td>
    </tr>
    <tr>
      <td><strong>Sinatra</strong> + Falcon</td>
      <td>3,921.91</td>
      <td>1,163.09</td>
      <td>571.56</td>
      <td>515.66</td>
      <td>96.964 ms</td>
    </tr>
    <tr>
      <td><strong>Rails</strong> + Falcon</td>
      <td>965.99</td>
      <td>861.15</td>
      <td>821.44</td>
      <td>831.45</td>
      <td>60.136 ms</td>
    </tr>
  </tbody>
</table>

<em><sup>*</sup>LowLoop is the default server for Raindeer</em>

**See:** [raindeer-benchmarks](https://github.com/raindeer-rb/raindeer-benchmarks) repo

## IO-bound

Routing becomes a much less share of the time when it comes to IO, so we'll just benchmark with many routes.

### 100 routes

## Integrations

These integrations are experimental and don't suport the full Raindeer API such as `Interval` yet.

### Falcon

### Iodine

If you really need CPU-bound speed then you can boot Raindeer via Iodine. Compared to LowLoop, this currently increases requests per second by **~10-16%** and decreases latency by **~14%**. It involves a Rack adapter (for now) and of course, the absence of LowLoop with its Matrix, Interval and Async related features.

**Iodine Boot:**
```ruby
require 'iodine'
require_relative 'rack_adapter'

Iodine.threads = 1
Iodine.workers = 1

port = ENV.fetch('PORT', '4133')
address = ENV.fetch('BIND', '127.0.0.1')

Iodine.listen(service: :http, handler: RackAdapter.new, port:, address:)
Iodine.start
```

**Rack Adapter:**
```ruby
require 'bundler/setup'
require 'rack'
require 'raindeer/boot'

Low::Events::RequestEvent.define do |observers|
  observers << Providers['rain.router']
end

class RackAdapter
  HEADER_NAME_CACHE = Hash.new { |cache, key| cache[key] = key.delete_prefix('HTTP_').tr('_', '-').downcase.freeze }

  def call(env)
    http_request = build_request(env)
    response = Low::Events::RequestEvent.take(request: http_request).response
    build_rack_response(response)
  end

  private

  BODY_METHODS = %w[POST PUT PATCH].freeze

  def build_request(env)
    body = env['rack.input']&.read if BODY_METHODS.include?(env['REQUEST_METHOD'])
    body = nil if body.nil? || body.empty?

    headers = Protocol::HTTP::Headers.new(
      env.filter_map do |key, value|
        next unless key.start_with?('HTTP_')

        [HEADER_NAME_CACHE[key], value]
      end
    )

    query = env['QUERY_STRING']
    path = query.nil? || query.empty? ? env['PATH_INFO'] : "#{env['PATH_INFO']}?#{query}"
    authority = env['HTTP_HOST'] || "#{env['SERVER_NAME']}:#{env['SERVER_PORT']}"

    Protocol::HTTP::Request.new(
      env['rack.url_scheme'],
      authority,
      env['REQUEST_METHOD'],
      path,
      'HTTP/1.1',
      headers,
      body
    )
  end

  def build_rack_response(response)
    body_data = response.body.respond_to?(:file) ? File.binread(response.body.file.path) : (response.body.read || '')

    rack_headers = {}
    response.headers.fields.each { |key, value| rack_headers[key.to_s] = value.to_s }
    rack_headers['content-length'] ||= body_data.bytesize.to_s

    [response.status, rack_headers, [body_data]]
  end
end
```
