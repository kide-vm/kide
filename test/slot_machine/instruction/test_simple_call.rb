require_relative "helper"

module SlotMachine
  class TestSimpleCall <  SlotMachineInstructionTest
    include Parfait::MethodHelper

    def instruction
      SimpleCall.new( make_method )
    end
    def test_len
      assert_equal 7 , all.length , all_str
    end
    def test_1_load_return_label
      assert_load risc(1) , Risc::Label , :r1
      assert_label risc(1).constant , "continue_"
    end
    def test_2_load_next_message
      assert_slot_to_reg risc(2) ,:r0 , 1 , :r2
    end
    def test_3_store_return_address
      assert_reg_to_slot risc(3) , :r1 , :r2 , 4
    end
    def test_4_swap_messages
      assert_slot_to_reg risc(4) ,:r0 , 1 , :r0
    end
    def test_5_call
      assert_equal Risc::FunctionCall , risc(5).class
      assert_equal :meth , risc(5).method.name
    end
    def test_6_label
      assert_label risc(6) , "continue_"
    end
  end
end
