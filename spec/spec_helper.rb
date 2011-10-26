$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'rubygems'
require 'bundler'

Bundler.setup

require 'rspec'
require 'rack/test'

# Set's the appropriate server settings for Ripple
ENV['RACK_ENV'] = 'test'

require 'app'

require 'support/ripple_test_server'
