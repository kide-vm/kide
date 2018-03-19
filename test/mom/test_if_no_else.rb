require_relative "helper"

module Risc
  class TestIfNoElse < MiniTest::Test
    include Statements

    def setup
      super
      @input = "if(@a) ; arg = 5 ; end"
      @expect = [SlotToReg, SlotToReg, LoadConstant, IsSame, Label, LoadConstant ,
                 SlotToReg, RegToSlot, Label]
    end

    def test_if_instructions
      assert_nil msg = check_nil , msg
    end

    def ttest_if_instructions
      produced = produce_body
      assert_equal 5 , produced.class , produced
    end
  end
end
