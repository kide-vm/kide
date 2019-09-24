require_relative "helper"

module RubyX
  module Macro
    class TestIntegerDiv4 < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Integer < Data4
          def div4
            X.div4
          end
        end
GET
      end
      def test_mom_meth
        assert_equal :div4 , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.mom_instructions.length
      end
      def test_instr_get
        assert_equal Mom::Div4 , compiler.mom_instructions.next.class
      end
      def test_risc
        assert_equal 41 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
