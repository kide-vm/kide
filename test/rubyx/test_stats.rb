require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliStats < MiniTest::Test

    def test_stats
      out, err = capture_io {RubyXC.start(["stats" ,
            "--integers=50","--messages=50", "test/mains/source/00_one-call__8.rb"])}
      assert out.include?("Space") , out
      assert out.include?("Total") , out
      assert out.include?("Objects=") , out
    end
  end
end
