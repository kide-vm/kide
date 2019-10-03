require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntOpPl < BootTest
      def setup
        @method = get_compiler("Integer",:and)
      end
      def test_slot_length
        assert_equal :& , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 42 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntOpMM < BootTest
      def setup
        @method = get_compiler("Integer",:or)
      end
      def test_slot_length
        assert_equal :| , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 42 , @method.to_risc.risc_instructions.length
      end
    end
  end
end
