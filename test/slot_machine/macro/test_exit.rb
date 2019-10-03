require_relative "helper"

module SlotMachine
  module Builtin
    class TestObjectExitRisc < BootTest
      def setup
        super
        @method = get_compiler("Object",:exit)
      end
      def test_slot_length
        assert_equal :exit , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 40 , @method.to_risc.risc_instructions.length
      end
    end
  end
end
