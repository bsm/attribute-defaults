# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "attribute-defaults"
  s.summary     = "Specify default values for ActiveRecord attributes"
  s.description = "ActiveRecord plugin that allows to specify default values for attributes"
  s.version     = '0.2.0'

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/attribute-defaults"

  s.require_path = 'lib'
  s.files        = Dir['LICENSE', 'README.rdoc', 'lib/**/*']

  s.add_dependency "activerecord", "~> 3.0.0"
  s.add_dependency "activesupport", "~> 3.0.0"
end
