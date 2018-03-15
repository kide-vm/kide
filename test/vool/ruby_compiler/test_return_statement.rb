require_relative "helper"

module Vool
  class TestReturnStatement < MiniTest::Test

    def test_return_const
      lst = RubyCompiler.compile( "return 1" )
      assert_equal ReturnStatement , lst.class
    end

    def test_return_value
      lst = RubyCompiler.compile( "return 1" )
      assert_equal 1 , lst.return_value.value
    end

    def test_return_send
      lst = RubyCompiler.compile( "return foo" )
      assert_equal SendStatement , lst.return_value.class
      assert_equal :foo , lst.return_value.name
    end

  end
end
