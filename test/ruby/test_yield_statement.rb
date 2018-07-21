require_relative "helper"

module Ruby
  class TestYieldStatementVool < MiniTest::Test
    include RubyTests

    def setup()
      input = "yield(0)"
      @lst = compile( input ).to_vool
    end
    def test_block
      assert_equal Vool::YieldStatement , @lst.class
    end
    def test_block_args
      assert_equal Vool::IntegerConstant , @lst.arguments.first.class
    end
  end
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
  end
end
