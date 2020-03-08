require_relative "helper"

module SlotMachine
  class TestReturnSequence < SlotMachineInstructionTest
    def instruction
      ReturnSequence.new("source")
    end
    def test_len
      assert_equal 7 , all.length , all_str
    end
    def test_1_load_return_value
      assert_slot_to_reg 1,:message , 6 , "message.caller"
    end
    def test_2_load_caller
      assert_slot_to_reg 2,"message.caller" , 5 , "message.caller.return_value"
    end
    def test_3_store_return_in_caller
      assert_reg_to_slot 3, "message.caller.return_value" , "message.caller" , 5
    end
    def test_4_load_return_address
      assert_slot_to_reg 4,:message , 4 , "message.return_address"
    end
    def test_5_swap_messages
      assert_slot_to_reg 5,:message, 6 , :message
    end
    def test_6_do_return
      assert_equal Risc::FunctionReturn , risc(6).class
      assert_equal :"message.return_address" , risc(6).register.symbol
    end
  end
end
