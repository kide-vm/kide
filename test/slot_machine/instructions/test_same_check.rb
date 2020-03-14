require_relative "helper"

module SlotMachine
  class TestSameCheck < SlotMachineInstructionTest
    def instruction
      left = SlottedMessage.new( [:caller])
      right = SlottedMessage.new( [:next_message])
      SameCheck.new(left , right , Label.new("ok" , "target"))
    end
    def test_len
      assert_equal 5 , all.length
      assert_equal Risc::Label , all.first.class
    end
    def test_1_slot
      assert_slot_to_reg 1,:message , 6 , :"message.caller"
    end
    def test_2_slot
      assert_slot_to_reg 2,:message , 1 , :"message.next_message"
    end
    def test_3_op
      assert_operator 3, :- , "message.caller" , "message.next_message" , "op_-_"
    end
    def test_4_not_zero
      assert_not_zero 4 , "target"
    end
  end
end
