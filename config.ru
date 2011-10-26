require 'rubygems'
require 'bundler'

Bundler.setup

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'app'))
require 'app'
run App
