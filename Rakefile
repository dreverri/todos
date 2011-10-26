require 'rubygems'
require 'bundler'

Bundler.setup

require 'rspec/core'
require 'rspec/core/rake_task'

desc "Run Specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.ruby_opts = "-Ispec"
  spec.pattern = "spec/app/**/*_spec.rb"
  spec.rspec_opts = ["--format", "doc"]
end

task :default => :spec
