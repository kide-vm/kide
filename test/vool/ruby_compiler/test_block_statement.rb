require_relative "helper"

module Vool
  class TestBlockStatement < MiniTest::Test

    def setup()
      input = "plus_one{|arg1| arg1 + 1 } "
      @lst = RubyCompiler.compile( input )
    end
    def test_method
      assert_equal SendStatement , @lst.class
    end
    def test_block
      assert_equal BlockStatement , @lst.block.class
    end

    def test_method_name
      assert_equal :plus_one , @lst.name
    end

    def test_block_args
      assert_equal [:arg1] , @lst.block.args
    end
    def test_block_body
      assert_equal SendStatement , @lst.block.body.class
      assert_equal 1 , @lst.block.body.arguments.length
    end
  end
end
