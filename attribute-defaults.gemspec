Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.5.0'

  s.name        = 'attribute-defaults'
  s.summary     = 'Specify default values for ActiveRecord attributes'
  s.description = 'ActiveRecord plugin that allows to specify default values for attributes'
  s.version     = '0.9.0'

  s.authors     = ['Dimitrij Denissenko']
  s.email       = 'dimitrij@blacksquaremedia.com'
  s.homepage    = 'https://github.com/bsm/attribute-defaults'

  s.require_path = 'lib'
  s.files        = Dir['LICENSE', 'README.rdoc', 'lib/**/*']

  s.add_dependency 'activerecord', '>= 5.0.0', '< 7.0.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop-bsm'
  s.add_development_dependency 'sqlite3'
end
