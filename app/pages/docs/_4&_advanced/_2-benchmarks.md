---
title: Benchmarks
published: true
---

## CPU-bound

**Configuration:**
- 1 thread/fiber
- 100 routes

> ![note]
> **Requests Per Second:** This CPU-bound metric is a relatively small slice of time in comparison to the typical IO-bound tasks of web applications, such as waiting for the database.

<table>
  <thead>
    <tr>
      <th>Server</th>
      <th>Req/s</th>
      <th>Mean latency</th>
      <th>p50</th>
      <th>p90</th>
      <th>p99</th>
      <th>Failed requests</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Raindeer + LowLoop</td>
      <td>17134.66</td>
      <td>2.918 ms</td>
      <td>3 ms</td>
      <td>3 ms</td>
      <td>4 ms</td>
      <td>0</td>
    </tr>
    <tr>
      <td>Raindeer + Falcon</td>
      <td>14499.04</td>
      <td>3.449 ms</td>
      <td>3 ms</td>
      <td>4 ms</td>
      <td>8 ms</td>
      <td>0</td>
    </tr>
    <tr>
      <td>Roda + Falcon</td>
      <td>11469.40</td>
      <td>4.359 ms</td>
      <td>4 ms</td>
      <td>5 ms</td>
      <td>5 ms</td>
      <td>0</td>
    </tr>
    <tr>
      <td>Hanami + Falcon</td>
      <td>6619.51</td>
      <td>7.553 ms</td>
      <td>7 ms</td>
      <td>8 ms</td>
      <td>9 ms</td>
      <td>0</td>
    </tr>
    <tr>
      <td>Sinatra + Falcon</td>
      <td>5691.24</td>
      <td>8.785 ms</td>
      <td>9 ms</td>
      <td>9 ms</td>
      <td>10 ms</td>
      <td>0</td>
    </tr>
    <tr>
      <td>Rails + Falcon</td>
      <td>2709.77</td>
      <td>18.452 ms</td>
      <td>18 ms</td>
      <td>20 ms</td>
      <td>22 ms</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

<em><sup>*</sup>LowLoop is the default server for Raindeer</em>

**See:** [raindeer-benchmarks](https://github.com/raindeer-rb/raindeer-benchmarks) repo

## Integrations

### Raindeer + Iodine [EXPERIMENTAL]

If you really need CPU-bound speed then you can boot Raindeer via Iodine. Currently this increases requests per second by **~10,000** and decreases latency by **~1ms**. It involves a Rack adapter (for now) and of course, the absence of LowLoop with its Matrix, Interval and Async related features.

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
