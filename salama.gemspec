# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'salama'
  s.version = '0.0.1'

  s.authors = ['Torsten Ruger']
  s.email = 'torsten@villataika.fi'
  s.extra_rdoc_files = ['README.md']
  s.files = %w(README.md LICENSE.txt Rakefile) + Dir.glob("lib/**/*")
  s.homepage = 'https://github.com/salama/salama'
  s.license = 'MIT'
  s.require_paths = ['lib']
  s.summary = 'Salama is a native object vm without any c, one day possibly a ruby vm'  
  
  s.add_dependency 'parslet', '~> 1.6.1'
end
