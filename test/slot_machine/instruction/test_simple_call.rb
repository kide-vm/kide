require_relative "helper"

module SlotMachine
  class TestSimpleCall <  SlotMachineInstructionTest
    include Parfait::MethodHelper

    def instruction
      SimpleCall.new( make_method )
    end
    def est_len
      assert_equal 7 , all.length , all_str
    end
    def test_1_load_return_label
      assert_load risc(1) , Risc::Label
      assert_label risc(1).constant , "continue_"
    end
    def test_2_load_next_message
      assert_slot_to_reg risc(2) ,:message , 1 , :"message.next_message"
    end
    def test_3_store_return_address
      assert risc(3).register.is_object?
      assert_equal 4,  risc(3).index
      assert_equal :"message.next_message",  risc(3).array.symbol
    end
    def test_4_swap_messages
      assert_slot_to_reg risc(4) ,:message , 1 , :message
    end
    def test_5_call
      assert_equal Risc::FunctionCall , risc(5).class
      assert_equal :meth , risc(5).method.name
    end
    def test_6_label
      assert_equal Risc::Label , risc(6).class
      assert_label risc(6) , "continue_"
    end
  end
end
