require_relative "helper"

module RubyX
  module Macro
    class TestWordPutstring < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Word < Data8
          def putstring
            X.putstring
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :putstring , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::Putstring , compiler.slot_instructions.next.class
      end
      def test_risc
        assert_equal 44 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
