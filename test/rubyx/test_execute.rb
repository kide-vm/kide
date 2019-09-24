require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliExecute < MiniTest::Test

    def test_execute
      assert_output(/Running/) {RubyXC.start(["execute" ,
            "--integers=50","--messages=50" , "test/mains/source/00_one-call__8.rb"])}
    end
  end
end
