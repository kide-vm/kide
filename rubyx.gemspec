# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'rubyx'
  s.version = '0.6.0'

  s.authors = ['Torsten Ruger']
  s.email = 'torsten@villataika.fi'
  s.extra_rdoc_files = ['README.md']
  s.files = %w(README.md LICENSE.txt Rakefile) + Dir.glob("lib/**/*")
  s.homepage = 'https://github.com/ruby-x/salama'
  s.license = 'MIT'
  s.require_paths = ['lib']
  s.summary = 'RubyX is a native object vm without any c, one day possibly a ruby vm'

  s.add_dependency "parser" , "~> 2.3.0"
  s.add_dependency "salama-object-file" , "~> 0.3"
end
