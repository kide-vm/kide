require_relative "helper"

module RubyX
  module Macro
    class TestObjectMissing < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Space
          def main(arg)
            return
          end
        end
        class Object
          def method_missing(at)
            X.method_missing
          end
        end
GET
      end
      def test_mom_meth
        assert_equal :method_missing , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.mom_instructions.length
      end
      def test_instr_get
        assert_equal Mom::MethodMissing , compiler.mom_instructions.next.class
      end
      def test_risc
        assert_equal 14 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
