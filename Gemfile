source "https://rubygems.org"

gem "rubyx" , :path => "."
#gem "ast"
#, :github => "whitequark/ast" , branch: :master

gem "rake"
gem "rye"

gem "salama-object-file" , :git => "https://github.com/ruby-x/rubyx-object-file"
#gem "salama-object-file" , :path => "../salama-object-file"

group :test do
  gem "codeclimate-test-reporter" , require: false
  gem "simplecov"
  gem "minitest-color"
end

group :development do
  gem "thor" , "0.19.1"
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-minitest'
  gem "rb-readline"
end
