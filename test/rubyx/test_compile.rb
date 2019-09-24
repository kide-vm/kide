require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliCompile < MiniTest::Test

    def test_compile
      assert_output(/compiling/) {RubyXC.start(["compile" ,
            "--integers=50","--messages=50","test/mains/source/00_one-call__8.rb"])}
    end
  end
end
