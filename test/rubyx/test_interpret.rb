require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliInterpret < MiniTest::Test

    def test_interpret
      assert_output(/interpreting/) {RubyXC.start(["interpret" ,
            "--integers=50","--messages=50" , "test/mains/source/00_one-call__8.rb"])}
    end
  end
end
