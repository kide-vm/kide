require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntDiv10Risc < BootTest
      def setup
        @method = get_compiler("Integer",:div10)
      end
      def test_slot_length
        assert_equal :div10 , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 69 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_return
        assert_return(61)
      end
      def test_all
        assert_slot_to_reg 23 , "message" , 2 , "message.receiver"
        assert_slot_to_reg 24 , "message.receiver" , 2 , "message.receiver.data_1"
        assert_transfer 25 , "message.receiver.data_1" , "integer_1"
        assert_transfer 26 , "message.receiver.data_1" , "integer_reg"
        assert_data 27 , 1
        assert_operator 28 , :>> , :integer_1 , :integer_const
        assert_data 29 , 2
        assert_operator 30 , :>> , :integer_reg , :integer_const
        assert_operator 31 , :+ , :integer_reg , :integer_1
        assert_data 32 , 4
        assert_transfer 33 , :integer_reg , :integer_1
        assert_operator 34 , :>> , :integer_reg , :integer_1
        assert_operator 35 , :+ , :integer_reg , :integer_1
        assert_data 36 , 8
        assert_transfer 37 , :integer_reg , :integer_1
        assert_operator 38 , :>> , :integer_1 , :integer_const
        assert_operator 39 , :+ , :integer_reg , :integer_1
        assert_data 40 , 16
        assert_transfer 41 , :integer_reg , :integer_1
        assert_operator 42 , :>> , :integer_1 , :integer_const
        assert_operator 43 , :+ , :integer_reg , :integer_1
        assert_data 44 , 3
        assert_operator 45 , :>> , :integer_reg , :integer_const
        assert_data 46 , 10
        assert_transfer 47 , :integer_reg , :integer_1
        assert_operator 48 , :* , :integer_1 , :integer_const
        assert_operator 49 , :- , "message.receiver.data_1" , :integer_1
        assert_transfer 50 , "message.receiver.data_1" , :integer_1
        assert_data 51 , 6
        assert_operator 52 , :+ , :integer_1 , :integer_const
        assert_data 53 , 4
        assert_operator 54 , :>> , :integer_1 , :integer_const
        assert_operator 55 , :+ , :integer_reg , :integer_1
        assert_reg_to_slot 56 , :integer_reg , "id_factory_.next_object" , 2
        assert_reg_to_slot 57 , "id_factory_.next_object" , :message , 5
        assert_slot_to_reg 58 ,:message , 5 , "message.return_value"
        assert_reg_to_slot 59 , "message.return_value" , :message , 5
        assert_branch 60 , "return_label"
        assert_label 61 , "return_label"
      end
    end
  end
end
