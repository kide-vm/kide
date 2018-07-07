require_relative "helper"

module Vool
  class TestYieldStatementX < MiniTest::Test
    include RubyTests

    def setup()
      input = "def plus_one; yield(0) ; end "
      @lst = compile( input )
    end
    def test_method
      assert_equal MethodStatement , @lst.class
    end
    def test_block
      assert_equal YieldStatement , @lst.body.class
    end
    def test_block_args
      assert_equal IntegerConstant , @lst.body.arguments.first.class
    end
    def test_method_yield?
      assert_equal true , @lst.has_yield?
    end
    def test_method_args
      Parfait.boot!
      assert_equal 2 , @lst.make_arg_type.get_length
    end
  end
end
