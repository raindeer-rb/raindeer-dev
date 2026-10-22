# frozen_string_literal: true

require 'bundler/setup'
require_relative 'assets'

Assets.build

require 'raindeer/boot'
