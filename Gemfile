source "http://rubygems.org"

gem "salama" , :path => "."
gem "ast" , :github => "whitequark/ast" , branch: :master

gem "rake"
gem "rye"

gem "salama-object-file" , :github => "ruby-x/salama-object-file"
#gem "salama-object-file" , :path => "../salama-object-file"

gem "codeclimate-test-reporter", require: nil


group :development do
  gem "thor" , "0.19.1"
  gem "minitest"
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-minitest'
  gem "rb-readline"
end
