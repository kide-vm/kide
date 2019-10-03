require_relative "helper"

module Ruby
  class TestYieldStatement < MiniTest::Test
    include RubyTests

    def setup()
      input = "yield(0)"
      @lst = compile( input )
    end
    def test_block
      assert_equal YieldStatement , @lst.class
    end
    def test_block_args
      assert_equal IntegerConstant , @lst.arguments.first.class
    end
    def test_tos
      assert_equal "yield(0)" , @lst.to_s
    end
  end
  class TestYieldStatementSol < MiniTest::Test
    include RubyTests

    def setup()
      input = "yield(0)"
      @lst = compile( input ).to_sol
    end
    def test_block
      assert_equal Sol::YieldStatement , @lst.class
    end
    def test_block_args
      assert_equal Sol::IntegerConstant , @lst.arguments.first.class
    end
  end
end
