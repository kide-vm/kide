require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordSetRisc < BootTest
      def setup
        super
        @method = get_compiler("Word",:set)
      end
      def test_slot_length
        assert_equal :set_internal_byte , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 20 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg risc(1),:r0 , 2 , :r1
        assert_slot_to_reg risc(2),:r0 , 10 , :r2
        assert_reg_to_slot risc(3) , :r2 , :r0 , 5
        assert_slot_to_reg risc(4),:r0 , 9 , :r3
        assert_slot_to_reg risc(5),:r3 , 2 , :r3
        assert_slot_to_reg risc(6),:r2 , 2 , :r2
        assert_equal Risc::RegToByte , risc(7).class
        assert_slot_to_reg risc(8),:r0 , 5 , :r2
        assert_reg_to_slot risc(9) , :r2 , :r0 , 5
        assert_branch risc(10) , "return_label"
        assert_label risc(11) , "return_label"
      end
      def test_return
        assert_return(11)
      end
    end
  end
end
