require 'rake'
require 'rspec/mocks/version'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

desc 'Default: run specs.'
task default: %i[rubocop spec]
