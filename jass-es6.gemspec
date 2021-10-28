lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jass/version'

Gem::Specification.new do |s|
  s.name          = 'jass'
  s.version       = Jass::VERSION
  s.date          = '2021-10-28'
  s.authors       = ['Matthias Grosser']
  s.email         = ['mtgrosser@gmx.net']
  s.license       = 'MIT'

  s.summary       = 'ES6 goodness for Rails'
  s.description   = 'ES6 support for the Rails asset pipeline'
  s.homepage      = 'https://github.com/mtgrosser/jass'

  s.files = ['LICENSE', 'README.md', 'vendor/package.json', 'vendor/yarn.lock'] + Dir['lib/**/*.rb'] + Dir['vendor/node_modules/**/*']
  
  s.required_ruby_version = '>= 2.6.0'
  
  s.add_dependency 'nodo'
  s.add_dependency 'sprockets', '>= 3.7.0'
  
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'minitest'
end
