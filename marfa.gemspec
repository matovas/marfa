#!/usr/bin/env gem build
# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = 'marfa'
  s.version     = '0.3.0'
  s.required_ruby_version = '>= 2.3.0'
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Sinatra-based wrapper'
  s.description = 'Sinatra-based wrapper for our projects'
  s.authors     = ['Max Krechetov', 'Roman Yakushev', 'Anatoly Matov']
  s.email       = 'mvkrechetov@gmail.com'
  s.require_paths = ['lib']
  s.files       = `git ls-files`.split("\n")
  s.executables = ['marfa-start', 'marfa-build-js']
  s.homepage    = 'http://rubygems.org/gems/marfa'
  s.license     = 'MIT'

  s.add_dependency('haml', '~> 4.0', '>= 4.0.7')
  s.add_dependency('puma', '~> 3.7')
  s.add_dependency('rack_csrf', '~> 2.6')
  s.add_dependency('rake', '~> 12')
  s.add_dependency('redis', '~> 3.3', '>= 3.3.3')
  s.add_dependency('rest-client', '~> 2')
  s.add_dependency('sass', '~> 3.4', '>= 3.4.23')
  s.add_dependency('babel-transpiler', '~> 0.7')
  s.add_dependency('closure-compiler', '~> 1.1', '>= 1.1.12')
  s.add_dependency('sinatra', '~> 1.4', '>= 1.4.2')
  s.add_dependency('sinatra-contrib', '~> 1.4')
  s.add_dependency('device_detector', '~> 1.0')
  s.add_dependency('htmlcompressor', '~> 0.3.1')
  s.add_dependency('csso-rails', '~> 0.5.0')
  s.add_dependency('yard', '~> 0.9', '>= 0.9.8')
  s.add_dependency('yard-sinatra', '~> 1')
  s.add_dependency('compass', '~> 1.0', '>= 1.0.3')
  s.add_dependency('pony', '~> 1.11')
end
