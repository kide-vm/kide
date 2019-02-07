source "https://rubygems.org"

gem "rubyx" , :path => "."

gem "thor"

gem "rake"
gem "rye"

gem "rx-file" , git: "https://github.com/ruby-x/rx-file"
#gem "rx-file" , path: "../rx-file"
gem "minitest-parallel_fork"
group :test do
  gem "codeclimate-test-reporter" , require: false
  gem "simplecov"
  gem "minitest-color"
  gem 'minitest-fail-fast'
  gem 'minitest-profile'
  #gem "minitest-reporters"
  gem "net-ssh"
end

group :development do
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-minitest'
  gem "rb-readline"
end
