require_relative "helper"

module Vool
  class TestArray < MiniTest::Test

    def test_empty
      lst = RubyCompiler.compile( "[]")
      assert_equal ArrayStatement , lst.class
    end
    def test_one
      lst = RubyCompiler.compile( "[1]")
      assert_equal ArrayStatement , lst.class
    end
    def test_two
      lst = RubyCompiler.compile( "[1,2]")
      assert_equal ArrayStatement , lst.class
    end
  end
end
