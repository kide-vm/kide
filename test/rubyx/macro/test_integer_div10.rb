require_relative "helper"

module RubyX
  module Macro
    class TestIntegerDiv10 < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Integer < Data4
          def div10
            X.div10
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :div10 , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::Div10 , compiler.slot_instructions.next.class
      end
    end
  end
end
