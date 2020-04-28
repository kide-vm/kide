source "https://rubygems.org"

gem "rubyx" , :path => "."

gem "thor"

gem "rake"

gem "rx-file" , git: "https://github.com/ruby-x/rx-file"
#gem "rx-file" , path: "../rx-file"
group :test do
# reporter and parallel dont work together
#  gem "minitest-reporters"
  gem "codeclimate-test-reporter" , require: false
  gem "simplecov"
  gem "minitest-color"
  gem 'minitest-fail-fast'
  gem 'minitest-profile'
  gem "minitest-parallel_fork" , require: false
end

group :development do
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-minitest'
  gem "rb-readline"
end
