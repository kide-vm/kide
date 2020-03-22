require_relative "helper"

module RubyX
  module Macro
    class TestIntegerPlus < MiniTest::Test
      include MacroHelper
      def op ; :+ ; end
      def source
        <<GET
        class Integer  < Data4
          def #{op}(other)
            X.int_operator(:"#{op}")
          end
        end
GET
      end
      def test_slot_meth
        assert_equal op , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.slot_instructions.length
      end
      def test_instr_op
        assert_equal SlotMachine::IntOperator , compiler.slot_instructions.next.class
        assert_equal op , compiler.slot_instructions.next.operator
      end
    end
    class TestIntegerMinus < TestIntegerPlus
      def op ; :- ; end
    end
    class TestIntegerRS < TestIntegerPlus
      def op ; :<< ; end
    end
    class TestIntegerRS < TestIntegerPlus
      def op ; :>> ; end
    end
    class TestIntegerMul < TestIntegerPlus
      def op ; :* ; end
    end
    class TestIntegerAnd < TestIntegerPlus
      def op ; :& ; end
    end
    class TestIntegerOr < TestIntegerPlus
      def op ; :| ; end
    end
  end
end
