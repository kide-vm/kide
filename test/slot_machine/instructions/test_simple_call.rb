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
      assert_load 1 , Risc::Label , "id_"
      assert_label risc(1).constant , "after_meth_" , 1
    end
    def test_2_load_next_message
      assert_slot_to_reg 2 ,:message , 1 , :"message.next_message"
    end
    def test_3_store_return_address
      assert_reg_to_slot 3 , "id_" , :"message.next_message" , 4
    end
    def test_4_swap_messages
      assert_slot_to_reg 4 ,:message , 1 , :message
    end
    def test_5_call
      assert_equal Risc::FunctionCall , risc(5).class
      assert_equal :meth , risc(5).method.name
    end
    def test_6_label
      assert_label 6 , "after_meth_"
    end
  end
end
