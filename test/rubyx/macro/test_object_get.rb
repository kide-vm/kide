require_relative "helper"

module RubyX
  module Macro
    class TestObjectGet < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Object
          def get_internal_word(at)
            X.get_internal_word
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :get_internal_word , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::GetInternalWord , compiler.slot_instructions.next.class
      end
    end
  end
end
