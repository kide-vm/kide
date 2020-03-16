require_relative "helper"

module SlotMachine
  module Builtin
    class TestObjectInitRisc < BootTest
      def setup
        compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
        coll = compiler.ruby_to_slot( get_preload("Space.main") )
        @method = SlotCollection.create_init_compiler
      end
      def test_slot_length
        assert_equal :__init__ , @method.callable.name
        assert_equal 2 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 20 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_load 1 , Parfait::Factory , "id_factory_"
        assert_slot_to_reg 2 , "id_factory_" , 2 , :message
        assert_slot_to_reg 3 ,:message , 1 , "message.next_message"
        assert_reg_to_slot 4 , "message.next_message" , "id_factory_" , 2
        assert_load 5 , Parfait::CallableMethod , "id_callablemethod_"
        assert_slot_to_reg 6 ,:message , 1 , "message.next_message"
        assert_reg_to_slot 7 , "id_callablemethod_" , "message.next_message" , 7
        assert_slot_to_reg 8 ,:message , 1 , :message
        assert_load 9 , Parfait::Space , "id_space_"
        assert_reg_to_slot 10 , "id_space_" , :message , 2
        assert_load 11 , Risc::Label , "id_label_"
        assert_reg_to_slot 12 , "id_label_" , :message , 4
        assert_function_call 13 , :main
        assert_label 14 , "Object.__init__"
        assert_transfer 15 , :message , :saved_message
        assert_slot_to_reg 16 ,:message , 5 , :"message.return_value"
        assert_slot_to_reg 17 ,:"message.return_value" , 2 , "message.return_value.data_1"
        assert_transfer 18 , "message.return_value.data_1" , :syscall_1
        assert_syscall 19, :exit
      end
    end
  end
end
