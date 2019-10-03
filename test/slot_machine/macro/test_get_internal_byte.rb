require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordGetRisc < BootTest
      def setup
        super
        @method = get_compiler("Word",:get)
      end
      def test_slot_length
        assert_equal :get_internal_byte , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 41 , @method.to_risc.risc_instructions.length
      end
    end
  end
end
