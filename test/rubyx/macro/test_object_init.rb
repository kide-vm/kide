require_relative "helper"

module RubyX
  module Macro
    class TestObjectInit < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Object
          def __init(at)
            X.__init
          end
        end
GET
      end
      def test_slot_meth
        assert_equal :__init , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_get
        assert_equal SlotMachine::Init , compiler.slot_instructions.next.class
      end
    end
  end
end
