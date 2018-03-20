require_relative "helper"

module Risc
  class TestWhile < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(@a) ; arg = 5 end"
      @expect = [Label, SlotToReg, SlotToReg, LoadConstant, IsSame, LoadConstant ,
                 IsSame, LoadConstant, SlotToReg, RegToSlot, Label, Label]
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end

    def test_false_load
      produced = produce_body
      assert_equal Mom::FalseConstant , produced.next(3).constant.known_object.class
    end
    def test_false_check
      produced = produce_body
      assert_equal produced.next(11) , produced.next(4).label
    end
    def test_nil_load
      produced = produce_body
      assert_equal Mom::NilConstant , produced.next(5).constant.known_object.class
    end
    def test_nil_check
      produced = produce_body
      assert_equal produced.next(11) , produced.next(6).label
    end

    def test_merge_label
      produced = produce_body
      assert produced.next(11).name.start_with?("merge_label")
    end

    def test_true_jump # should jumpp to merge label
      produced = produce_body
      assert_equal "Jump" , produced.next(10).name
    end
  end
end
