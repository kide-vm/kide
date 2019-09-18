require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliCompile < MiniTest::Test

    def test_compile
      assert_output(/compiling/) {RubyXC.start(["compile" , "--preload",
            "--integers=50","--messages=50","test/mains/source/add__4.rb"])}
    end
  end
end
