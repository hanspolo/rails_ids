$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rails_ids/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails_ids'
  s.version     = RailsIds::VERSION
  s.authors     = ['Philipp Hirsch']
  s.email       = ['itself@hanspolo.net']
  s.homepage    = 'https://github.com/hanspolo/rails_ids'
  s.summary     = 'Implementation of the OWASP AppSensor Guide for Ruby on Rails'
  s.description = 'Description of RailsIds.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails',                           '~> 4.2.6'
  s.add_dependency 'simple_form',                     '~> 3.2.1'
  s.add_dependency 'rb-libsvm',                       '~> 1.4.0'

  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'database_cleaner',    '~> 1.5.3'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rdoc',                '~> 4.2.2'
  s.add_development_dependency 'rspec',               '~> 3.4'
  s.add_development_dependency 'rspec-rails',         '~> 3.4'
end
