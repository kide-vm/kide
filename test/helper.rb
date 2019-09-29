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
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'test'))

#require "minitest/reporters"
#Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'rubyx'

require_relative "support/options"
require_relative "support/parfait_test"
require_relative "support/fake_int"
require_relative "support/fake_compiler"
require_relative "support/risc_assert"
require_relative "support/risc_interpreter"
