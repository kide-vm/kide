require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliStats < MiniTest::Test

    def test_stats
      out, err = capture_io {RubyXC.start(["stats" ,"--preload", "test/mains/source/add__4.rb"])}
      assert out.include?("Space") , out
      assert out.include?("Total") , out
      assert out.include?("Objects=") , out
    end
  end
end
