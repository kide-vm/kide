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
        assert_equal 14 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_transfer 1 , :r1 , :r1
        assert_syscall 2 , :died
        assert_slot_to_reg 3 , :message , 5 , "message.return_value"
        assert_reg_to_slot 4 , "message.return_value" , :message , 5
        assert_branch 5 , "return_label"
        assert_label 6 , "return_label"
      end
      def test_return
        assert_return(6)
      end
    end
  end
end
