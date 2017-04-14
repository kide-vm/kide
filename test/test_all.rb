#!/usr/bin/env ruby

require 'simplecov'
SimpleCov.start if ENV["CODECLIMATE_REPO_TOKEN"]

Dir["**/test_*.rb"].each { |f|
  next if f.include?("stash/")
  require_relative "../#{f}"
}
