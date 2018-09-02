require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'simplecov'
  SimpleCov.start { add_filter "/test/" }
end

require "minitest/color"
require "minitest/autorun"
require "minitest/fail_fast" unless ENV["TEST_ALL"]
require 'minitest/profile'
#require "minitest/reporters"
#Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'test'))

require 'rubyx'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
