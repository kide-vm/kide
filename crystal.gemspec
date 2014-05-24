# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'crystal'
  s.version = '0.0.1'

  s.authors = ['Torsten Ruger']
  s.email = 'torsten@villataika.fi'
  s.extra_rdoc_files = ['README.markdown']
  s.files = %w(README.markdown LICENSE.txt Rakefile) + Dir.glob("lib/**/*")
  s.homepage = 'https://github.com/ruby-in-ruby/crystal'
  s.license = 'MIT'
  s.require_paths = ['lib']
  s.summary = 'Hey crystal, what do you want to be when you grow up:  I like pink and red, i wanna be a ruby'  
  
  s.add_dependency 'parslet', '~> 1.6.1'
end
