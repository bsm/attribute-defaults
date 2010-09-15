require 'rake'
require 'rspec/mocks/version'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Default: run specs.'
task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "attribute-defaults"
    gemspec.summary = "Assign default values after record initialization."
    gemspec.description = "Plugin for ActiveRecord"
    gemspec.email = "dimitrij@blacksquaremedia.com"
    gemspec.homepage = "http://github.com/bsm/attr_default"
    gemspec.authors = ["Dimitrij Denissenko"]
    gemspec.add_runtime_dependency "activerecord", ">= 3.0.0"
    gemspec.add_runtime_dependency "activesupport", ">= 3.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
