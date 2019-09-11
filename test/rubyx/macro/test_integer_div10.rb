require_relative "helper"

module RubyX
  module Macro
    class TestIntegerDiv10 < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Integer
          def div10
            X.div10
          end
        end
GET
      end
      def test_mom_meth
        assert_equal :div10 , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.mom_instructions.length
      end
      def test_instr_get
        assert_equal Mom::Div10 , compiler.mom_instructions.next.class
      end
      def test_risc
        assert_equal 70 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
