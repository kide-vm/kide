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
        assert_slot_to_reg at + 2 , "message.caller" , 5 , "message.caller.return_value"
        assert_reg_to_slot at + 3 ,"message.caller.return_value" , "message.caller" , 5
        assert_slot_to_reg at + 4 , :message , 4 , "message.return_address"
        assert_slot_to_reg at + 5 , :message , 6 , :message
        assert_equal Risc::FunctionReturn , risc(at + 6).class
        assert_label at + 7 , "unreachable"
      end
      def assert_allocate
        assert_load 1 , Parfait::Factory
        assert_slot_to_reg 2 , :r2 , 2 , :r1
        assert_load 3 , Parfait::NilClass
        assert_operator 4 , :- , :r3 , :r1
        assert_not_zero 5 , :label
        assert risc(5).label.name.to_s.start_with?("cont_label")
        assert_slot_to_reg 6 , :r2 , 3 , :r4
        assert_reg_to_slot 7 ,:r4 , :r2 , 2
        assert_load 8 , Parfait::CallableMethod
        assert_slot_to_reg 9 , :r0 , 1 , :r6
        assert_reg_to_slot 10 , :r5 , :r6 , 7
        assert_load 11 , Parfait::Factory
        assert_reg_to_slot 12 , :r7 , :r0 , 2
        assert_load 13 , Risc::Label
        assert_slot_to_reg 14 , :r0 , 1 , :r9
        assert_slot_to_reg 14 ,:r0,1,:r9
        assert_reg_to_slot 15 ,:r8,:r9,4
        assert_slot_to_reg 16 ,:r0 , 1 , :r0
        assert_equal Risc::FunctionCall, risc(17).class
        assert_equal :main, risc(17).method.name
        assert_label 18 , "continue_"
        assert_slot_to_reg 19 , :r2 , 2 , :r1
        assert_label 20 ,"cont_label_"
        assert_slot_to_reg 21 , :r1 , 1 , :r4
        assert_reg_to_slot 22 , :r4 , :r2 , 2
      end
    end
  end
end
