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
        assert_equal 41 , @method.to_risc.risc_instructions.length
      end
    end
  end
end
