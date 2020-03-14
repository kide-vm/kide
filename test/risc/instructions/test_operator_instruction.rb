require_relative "../helper"

module Risc
  class TestOperatorInstruction < MiniTest::Test
    def setup
      Parfait.boot!({})
      @left = RegisterValue.new(:left , :Integer)
      @right = RegisterValue.new(:right , :Integer)
    end
    def risc(i)
      @left.op :- , @right
    end
    def test_min
      assert_operator 1 , :- , :left , :right , "op_-_"
    end
    def test_reg
      result = risc(1).result
      assert_equal RegisterValue , result.class
      assert_equal "Integer_Type" , result.type.name
      assert result.symbol.to_s.start_with?("op_-_")
    end
  end
end
