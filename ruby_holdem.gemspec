# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ruby_holdem/version'


Gem::Specification.new do |spec|
  spec.name          = 'ruby_holdem'
  spec.version       = RubyHoldem::VERSION
  spec.authors       = ['Evan Rolfe']
  spec.email         = ['evanrolfe@gmail.com']
  spec.summary       = 'A gem for playing texas-holdem poker'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby-poker'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec-its'
end
