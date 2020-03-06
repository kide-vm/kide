require_relative "helper"

module SlotMachine
  module Builtin
    class TestObjectMissingRisc < BootTest
      def setup
        @method = get_compiler("Object",:missing)
      end
      def test_slot_length
        assert_equal :method_missing , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 15 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_transfer risc(1) , :r1 , :r1
        assert_equal Risc::Syscall, risc(2).class
        assert_slot_to_reg risc(3),:r0 , 5 , :r2
        assert_slot_to_reg risc(3),:r0 , 5 , :r2
        assert_reg_to_slot risc(4) , :r2 , :r0 , 5
        assert_branch risc(5) , "return_label"
        assert_label risc(6) , "return_label"
      end
      def test_return
        assert_return(6)
      end
    end
  end
end
