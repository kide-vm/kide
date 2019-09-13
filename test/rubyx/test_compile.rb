require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliCompile < MiniTest::Test

    def test_compile
      assert_output(/compiling/) {RubyXC.start(["compile" , "--preload","test/mains/source/add__4.rb"])}
    end
  end
end
