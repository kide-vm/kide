require_relative "helper"

module SlotMachine
  module Builtin
    class TestObjectExitRisc < BootTest
      def setup
        super
        @method = get_compiler("Object",:exit)
      end
      def test_slot_length
        assert_equal :exit , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 40 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        assert_reg_to_slot risc(23) , :r1  , :r0 , 5
        assert_transfer risc(24) , :r0 , :r8
        assert_slot_to_reg risc(25),:r0 , 5 , :r0
        assert_slot_to_reg risc(26),:r0 , 2 , :r0
        assert_equal Risc::Syscall, risc(27).class
        assert_equal :exit , risc(27).name
        assert_slot_to_reg risc(28),:r0 , 5 , :r2
        assert_reg_to_slot risc(29) , :r2  , :r0 , 5
        assert_branch risc(30) , "return_label"
        assert_label risc(31) , "return_label"
      end
      def test_return
        assert_return(31)
      end
    end
  end
end
