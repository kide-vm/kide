require_relative "helper"

module RubyX
  module Macro
    class TestWordSet < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Word < Data8
          def set_internal_byte( at , value)
            X.set_internal_byte
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :set_internal_byte , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::SetInternalByte , compiler.slot_instructions.next.class
      end
      def test_risc
        assert_equal 20 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
