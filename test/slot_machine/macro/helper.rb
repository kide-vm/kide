require_relative "../helper"

module SlotMachine
  module Builtin
    class BootTest < MiniTest::Test
      include Preloader

      def get_compiler(clazz , name)
        compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
        coll = compiler.ruby_to_slot( get_preload("Space.main;#{clazz}.#{name}") )
        @method = coll.method_compilers.last_compiler
        @method
      end

      def risc(at)
        @risc_i = @method.to_risc.risc_instructions unless @risc_i
        return @risc_i if at == 0
        @risc_i.next( at )
      end

      def assert_return(at)
        assert_label at , "return_label"
        assert_slot_to_reg at + 1 , :message , 6 , "message.caller"
        assert_slot_to_reg at + 2 , "message" , 5 , "message.return_value"
        assert_reg_to_slot at + 3 ,"message.return_value" , "message.caller" , 5
        assert_slot_to_reg at + 4 , :message , 4 , "message.return_address"
        assert_slot_to_reg at + 5 , :message , 6 , :message
        assert_equal Risc::FunctionReturn , risc(at + 6).class
        assert_label at + 7 , "unreachable"
      end
      def assert_allocate
        assert_load 1 , Parfait::Factory , "id_factory_"
        assert_load 2 , Parfait::NilClass , "id_nilclass_"
        assert_slot_to_reg 3 , "id_factory_" , 2 , "id_factory_.next_object"
        assert_operator 4 , :- , "id_nilclass_" , "id_factory_.next_object"
        assert_not_zero 5 , "cont_label"
        assert_slot_to_reg 6 , "id_factory_" , 2 , "id_factory_.next_object"
        assert_reg_to_slot 7 , "id_factory_.next_object" , "id_factory_" , 2
        assert_load 8 , Parfait::Factory , "id_factory_"
        assert_load 9 , Parfait::CallableMethod , "id_callablemethod"
        assert_slot_to_reg 10 , :message , 1 , "message.next_message"
        assert_reg_to_slot 11 , "id_callablemethod_" , "message.next_message" , 7
        assert_reg_to_slot 12 , "id_factory_" , :message , 2
        assert_load 13 , Risc::Label , "id_label"
        assert_slot_to_reg 14 , :message , 1 , "message.next_message"
        assert_reg_to_slot 15 , "id_label" , "message.next_message" , 4
        assert_slot_to_reg 16 ,:message , 1 , :message
        assert_equal Risc::FunctionCall, risc(17).class
        assert_equal :main, risc(17).method.name
        assert_label 18 , "after_main_"
        assert_label 19 , "cont_label"
        assert_slot_to_reg 20 , "id_factory_" , 2 , "id_factory_.next_object"
        assert_slot_to_reg 21 , "id_factory_" , 2 , "id_factory_.next_object"
        assert_reg_to_slot 22 , "id_factory_.next_object" , "id_factory_" , 2
      end
    end
  end
end
