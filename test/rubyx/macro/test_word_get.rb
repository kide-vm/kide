require_relative "helper"

module RubyX
  module Macro
    class TestWordGet < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Word < Data8
          def get_internal_byte(at)
            X.get_internal_byte
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :get_internal_byte , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::GetInternalByte , compiler.slot_instructions.next.class
      end
    end
  end
end
