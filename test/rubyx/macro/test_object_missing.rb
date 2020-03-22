require_relative "helper"

module RubyX
  module Macro
    class TestObjectMissing < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Object
          def method_missing(at)
            X.method_missing(:r1)
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :method_missing , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::MethodMissing , compiler.slot_instructions.next.class
      end
    end
  end
end
