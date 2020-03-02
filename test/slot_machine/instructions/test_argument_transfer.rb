require_relative "helper"

module SlotMachine
  class TestArgumentTransfer < SlotMachineInstructionTest
    def instruction
      receiver = SlottedMessage.new( [:arg1])
      arg = SlottedMessage.new( [:receiver , :type])
      ArgumentTransfer.new("" , receiver ,[arg])
    end
    def test_len
      assert_equal 8 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg risc(1) ,:message , 9 , :"message.arg1"
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:message , 1 , :"message.next_message"
    end
    def test_3_reg
      assert_reg_to_slot risc(3) , :"message.arg1" , :"message.next_message" , 2
    end
    def test_4_slot
      assert_slot_to_reg risc(4) ,:message , 2 , :"message.receiver"
    end
    def test_5
      assert_slot_to_reg risc(5) ,:"message.receiver" , 0 , :"message.receiver.type"
    end
    def test_6
      assert_slot_to_reg risc(6) ,:message , 1 , :"message.next_message"
    end
    def test_7
      assert_reg_to_slot risc(7) , :"message.receiver.type" , :"message.next_message" , 9
    end
  end
end
