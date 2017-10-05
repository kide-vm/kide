source "https://rubygems.org"

gem "rubyx" , :path => "."

gem "rake"
gem "rye"

gem "rx-file" , :git => "https://github.com/ruby-x/rx-file"

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
