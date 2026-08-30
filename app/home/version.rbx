# frozen_string_literal: true

require 'net/http'
require 'json'

class Version < LowNode
  ENDPOINT = 'https://rubygems.org/api/v1/versions/raindeer/latest.json'

  def initialize
    response = Net::HTTP.get(URI(ENDPOINT))
    @version = ::JSON.parse(response)['version']
  end

  def render
    <p id="version">v{@version}</p>
  end
end
