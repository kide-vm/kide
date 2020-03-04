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
    end
  end
end
