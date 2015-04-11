# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sorted/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'sorted-activerecord'
  spec.version       = Sorted::ActiveRecord::VERSION
  spec.authors       = ['Rufus Post']
  spec.email         = ['Rufus.Post@team.telstra.com']
  spec.summary       = 'Activerecord scoped for sorted.'
  spec.description   = 'Allows the use of the sorted gem with Activerecord.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 4.0.0'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'sorted', '~> 2.0.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'railties', '>= 4.0.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'sqlite3', '>= 1.3.5'
end
