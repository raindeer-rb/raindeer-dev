# frozen_string_literal: true

source 'https://rubygems.org'

gem 'raindeer', path: '../raindeer'

group :development do
  local_gems = {
    'low_event' => '../low_event',
    'low_loop' => '../low_loop',
    'low_node' => '../low_node',
    'low_type' => '../low_type',
    'lowkey' => '../lowkey',
    'lowload' => '../lowload',

    'antlers' => '../antlers',
    'expressions' => '../expressions',
    'observers' => '../observers',
    'providers' => '../providers'
  }

  local_gems.each do |name, relative_path|
    if File.exist?(File.expand_path(relative_path, __dir__))
      gem name, path: relative_path
    else
      gem name
    end
  end

  gem 'irb'
  gem 'rake', '~> 13.0'
  gem 'rubocop', require: false
end

group :testing do
  gem 'rspec'
  gem 'timecop'
end
