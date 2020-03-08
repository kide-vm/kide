require_relative "helper"

module SlotMachine
  class TestLabel < SlotMachineInstructionTest
    def instruction
      Label.new("ok" , "target")
    end
    def test_len
      assert_equal 2 , all.length
      assert_equal Risc::Label , all.first.class
    end
    def test_1_label
      assert_label 1 , "target"
    end
    def test_2_slot
      label = @instruction.risc_label( @compiler)
      assert_label label , "target" , 1
    end
  end
end
