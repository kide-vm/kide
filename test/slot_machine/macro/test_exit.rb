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
        assert_equal 39 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        assert_reg_to_slot 23 , "id_factory_.next_object"  , :message , 5
        assert_transfer 24 , :message , :saved_message
        assert_slot_to_reg 25 ,:message , 5 , :message
        assert_slot_to_reg 26 ,:message , 2 , "message.data_1"
        assert_syscall 27 , :exit
        assert_slot_to_reg 28 ,:message , 5 , "message.return_value"
        assert_reg_to_slot 29 , "message.return_value"  , :message , 5
        assert_branch 30 , "return_label"
        assert_label 31 , "return_label"
      end
      def test_return
        assert_return(31)
      end
    end
  end
end
