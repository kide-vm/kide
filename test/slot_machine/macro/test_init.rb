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
    end
  end
end
