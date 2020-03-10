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
        assert_load 1 , Parfait::Word  , "id_word_"
        assert_transfer 2 , "id_word_" , :r1
        assert_syscall 3 , :died
        assert_slot_to_reg 4 , :message , 5 , "message.return_value"
        assert_reg_to_slot 5 , "message.return_value" , :message , 5
        assert_branch 6 , "return_label"
        assert_label 7 , "return_label"
      end
      def test_return
        assert_return(7)
      end
    end
  end
end
