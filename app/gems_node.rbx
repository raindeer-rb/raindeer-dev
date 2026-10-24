# frozen_string_literal: true

require 'net/http'
require 'json'

class GemsNode < LowNode
  observe '/gems'

  def initialize(event:)
    @title = 'Gems'
    @gems = Raindeer.pages.list(folder: 'gems').sort_by do |gem|
      gem.title
    end

    # @gems = @gems.sort_by do |gem|
    #   response = Net::HTTP.get(URI("https://rubygems.org/api/v1/gems/#{gem.machine_name}.json"))
    #   ::JSON.parse(response)['downloads'].to_i
    # end.reverse
  end

  def render(event:)
    <{ Layout: title=@title section='section-gems' path='/gems' }>
      <div class="page-intro">
        <h1>{"Gems"}</h1>
        <p>{"The building blocks that make up Raindeer."}</p>
      </div>

      <div id="cards" class="grid">
        <{ for: gem in: @gems }>
          <{ Card card=gem }>
        <{ :for }>
      </div>
    <{ :Layout }>
  end
end
