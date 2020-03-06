require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordPutRisc < BootTest
      def setup
        @method = get_compiler("Word",:put)
      end
      def test_slot_length
        assert_equal :putstring , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 44 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        assert_reg_to_slot risc(23) , :r1  , :r0 , 5
        assert_slot_to_reg risc(24),:r0 , 2 , :r1
        assert_slot_to_reg risc(25),:r1 , 1 , :r2
        assert_transfer risc(26) , :r0 , :r8
        assert_equal Risc::Syscall, risc(27).class
        assert_transfer risc(28) , :r0 , :r3
        assert_transfer risc(29) , :r8 , :r0
        assert_slot_to_reg risc(30),:r0 , 5 , :r4
        assert_reg_to_slot risc(31) , :r3  , :r4 , 2
        assert_slot_to_reg risc(32),:r0 , 5 , :r2
        assert_reg_to_slot risc(33) , :r2  , :r0 , 5
        assert_branch risc(34) , "return_label"
        assert_label risc(35) , "return_label"
      end
      def test_return
        assert_return(35)
      end
    end
  end
end
