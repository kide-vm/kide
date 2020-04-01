ENV["TEST_ALL"] = "true"
require_relative "helper"
require "minitest/parallel_fork" if ENV["NCPU"]

Dir["test/**/test_*.rb"].each { |f|  require_relative "../#{f}" }
