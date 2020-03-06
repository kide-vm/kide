require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordGetRisc < BootTest
      def setup
        super
        @method = get_compiler("Object",:get)
      end
      def test_slot_length
        assert_equal :get_internal_word , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 18 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg risc(1),:r0 , 2 , :r1
        assert_slot_to_reg risc(2),:r0 , 9 , :r2
        assert_slot_to_reg risc(3),:r2 , 2 , :r2
        assert_slot_to_reg risc(4),:r1 , :r2 , :r1
        assert_reg_to_slot risc(5) , :r1 , :r0 , 5
        assert_slot_to_reg risc(6),:r0 , 5 , :r2
        assert_reg_to_slot risc(7) , :r2 , :r0 , 5
        assert_branch risc(8) , "return_label"
        assert_label risc(9) , "return_label"
      end
      def test_return
        assert_return(9)
      end
    end
  end
end
