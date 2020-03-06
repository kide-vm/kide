require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntDiv4Risc < BootTest
      def setup
        @method = get_compiler("Integer",:div4)
      end
      def test_slot_length
        assert_equal :div4 , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
        assert_equal :div4 , @method.callable.name
      end
      def test_risc_length
        assert_equal 41 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_return
        assert_return(32)
      end
      def test_all
        assert_slot_to_reg risc(23) , :r0 , 2 , :r2
        assert_slot_to_reg risc(24) , :r2 , 2 , :r2
        assert_data risc(25) , 2
        assert_operator risc(26) , :>> , :r2 , :r3
        assert_reg_to_slot risc(27) ,:r2 , :r1 , 2
        assert_reg_to_slot risc(28) ,:r1 , :r0 , 5
        assert_slot_to_reg risc(29) , :r0 , 5 , :r2
        assert_reg_to_slot risc(30) ,:r2 , :r0 , 5
        assert_branch risc(31) , "return_label"
      end
    end
  end
end
