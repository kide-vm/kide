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
      assert_slot_to_reg risc(1) ,:message , 6 , :"message.caller"
    end
    def test_2_slot
      assert_slot_to_reg risc(2) ,:message , 1 , :"message.next_message"
    end
    def test_3_op
      assert_operator risc(3) , :- , "message.caller" , "message.next_message"
    end
    def test_4_zero
      assert_equal Risc::IsNotZero , risc(4).class
      assert_label risc(4).label , "target"
    end
  end
end
