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
        assert_equal 19 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_load risc(1) , Parfait::Factory
        assert_slot_to_reg risc(2) , :r1 , 2 , :r0
        assert_slot_to_reg risc(3),:r0 , 1 , :r2
        assert_reg_to_slot risc(4) , :r2 , :r1 , 2
        assert_load risc(5) , Parfait::CallableMethod
        assert_slot_to_reg risc(6),:r0 , 1 , :r2
        assert_reg_to_slot risc(7) , :r1 , :r2 , 7
        assert_slot_to_reg risc(8),:r0 , 1 , :r0
        assert_load risc(9) , Parfait::Space
        assert_reg_to_slot risc(10) , :r3 , :r0 , 2
        assert_load risc(11) , Risc::Label
        assert_reg_to_slot risc(12) , :r4 , :r0 , 4
        assert_equal Risc::FunctionCall, risc(13).class
        assert_equal :main, risc(13).method.name
        assert_label risc(14) , "Object.__init__"
        assert_transfer risc(15) , :r0 , :r8
        assert_slot_to_reg risc(16),:r0 , 5 , :r0
        assert_slot_to_reg risc(17),:r0 , 2 , :r0
        assert_equal Risc::Syscall, risc(18).class
        assert_equal :exit, risc(18).name
      end
    end
  end
end
