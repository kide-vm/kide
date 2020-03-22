require_relative "helper"

module RubyX
  module Macro
    class TestObjectExit < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Object
          def exit(at)
            X.exit
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :exit , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::Exit , compiler.slot_instructions.next.class
      end
    end
  end
end
