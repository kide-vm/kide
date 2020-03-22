require_relative "helper"

module RubyX
  module Macro
    class TestIntegerSame < MiniTest::Test
      include MacroHelper
      def op ; :>= ; end # is == valid ??
      def len ; 24 ; end
      def source
        <<GET
        class Integer < Data4
          def #{op}(other)
            X.comparison(:"#{op}")
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
        assert_equal SlotMachine::Comparison , compiler.slot_instructions.next.class
        assert_equal op , compiler.slot_instructions.next.operator
      end
    end
    class TestIntegerLg < TestIntegerSame
      def op ; :> ; end
      def len ; 25 ; end
    end
    class TestIntegerSm < TestIntegerSame
      def op ; :< ; end
      def len ; 25 ; end
    end
    class TestIntegerLe < TestIntegerSame
      def op ; :>= ; end
    end
    class TestIntegerSe < TestIntegerSame
      def op ; :<= ; end
    end
  end
end
