lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jass/es6/version'

Gem::Specification.new do |s|
  s.name          = 'jass-es6'
  s.version       = Jass::ES6::VERSION
  s.date          = '2021-10-28'
  s.authors       = ['Matthias Grosser']
  s.email         = ['mtgrosser@gmx.net']
  s.license       = 'MIT'

  s.summary       = 'ES6 support for the Rails asset pipeline'
  s.description   = 'Integrate Rollup, Bublé and Nodent with the Rails asset pipeline'
  s.homepage      = 'https://github.com/mtgrosser/jass-es6'

  s.files = ['LICENSE', 'README.md', 'CHANGELOG.md'] + Dir['lib/**/*.rb']
  
  s.required_ruby_version = '>= 2.6.0'
  
  s.add_dependency 'nodo', '>= 1.6.3'
  
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'minitest'
end
