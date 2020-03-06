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
        assert_label risc(at) , "return_label"
        assert_slot_to_reg risc(at + 1) , :r0 , 5 , :r1
        assert_slot_to_reg risc(at + 2) , :r0 , 6 , :r2
        assert_reg_to_slot risc(at + 3) ,:r1 , :r2 , 5
        assert_slot_to_reg risc(at + 4) , :r0 , 4 , :r3
        assert_slot_to_reg risc(at + 5) , :r3 , 2 , :r3
        assert_slot_to_reg risc(at + 6) , :r0 , 6 , :r0
        assert_equal Risc::FunctionReturn , risc(at + 7).class
        assert_label risc(at + 8) , "unreachable"
      end
      def assert_allocate
        assert_load risc(1) , Parfait::Factory
        assert_slot_to_reg risc(2) , :r2 , 2 , :r1
        assert_load risc(3) , Parfait::NilClass
        assert_operator risc(4) , :- , :r3 , :r1
        assert_equal Risc::IsNotZero , risc(5).class
        assert risc(5).label.name.to_s.start_with?("cont_label")
        assert_slot_to_reg risc(6) , :r2 , 3 , :r4
        assert_reg_to_slot risc(7) ,:r4 , :r2 , 2
        assert_load risc(8) , Parfait::CallableMethod
        assert_slot_to_reg risc(9) , :r0 , 1 , :r6
        assert_reg_to_slot risc(10) , :r5 , :r6 , 7
        assert_load risc(11) , Parfait::Factory
        assert_reg_to_slot risc(12) , :r7 , :r0 , 2
        assert_load risc(13) , Risc::Label
        assert_slot_to_reg risc(14) , :r0 , 1 , :r9
        assert_slot_to_reg risc(14),:r0,1,:r9
        assert_reg_to_slot risc(15),:r8,:r9,4
        assert_slot_to_reg risc(16),:r0 , 1 , :r0
        assert_equal Risc::FunctionCall, risc(17).class
        assert_equal :main, risc(17).method.name
        assert_label risc(18) , "continue_"
        assert_slot_to_reg risc(19) , :r2 , 2 , :r1
        assert_label risc(20) ,"cont_label_"
        assert_slot_to_reg risc(21) , :r1 , 1 , :r4
        assert_reg_to_slot risc(22) , :r4 , :r2 , 2
      end
    end
  end
end
