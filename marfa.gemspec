#!/usr/bin/env gem build
# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = 'marfa'
  s.version     = '0.0.2.2'
  s.date        = '2017-01-19'
  s.summary     = 'Little Sinatra-based framework'
  s.description = 'Little Sinatra-based framework'
  s.authors     = ['Max Krechetov', 'Roman Yakushev', 'Anatoly Matov']
  s.email       = 'mvkrechetov@gmail.com'
  s.require_paths = ['lib']
  s.files       = `git ls-files`.split("\n")
  s.executables = ['marfa']
  s.homepage    = 'http://rubygems.org/gems/marfa'
  s.license     = 'MIT'

  s.add_dependency('haml')
  s.add_dependency('puma')
  s.add_dependency('rack_csrf')
  s.add_dependency('rake')
  s.add_dependency('redis')
  s.add_dependency('rest-client')
  s.add_dependency('sass')
  s.add_dependency('sinatra')
  s.add_dependency('sinatra-contrib')
  s.add_dependency('yard')
  s.add_dependency('yard-sinatra')
end
