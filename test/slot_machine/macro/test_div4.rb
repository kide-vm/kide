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
        assert_equal 40 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_return
        assert_return(32)
      end
      def test_all
        assert_slot_to_reg 23 , :message , 2 , "message.receiver"
        assert_slot_to_reg 24 , "message.receiver" , 2 , "message.receiver.data_1"
        assert_data 25 , 2
        assert_operator 26 , :>> , "message.receiver.data_1" , :integer_1
        assert_reg_to_slot 27 ,"message.receiver.data_1" , "id_factory_.next_object" , 2
        assert_reg_to_slot 28 ,"id_factory_.next_object" , :message , 5
        assert_slot_to_reg 29 , :message , 5 , "message.return_value"
        assert_reg_to_slot 30 , "message.return_value" , :message , 5
        assert_branch 31 , "return_label"
      end
    end
  end
end
