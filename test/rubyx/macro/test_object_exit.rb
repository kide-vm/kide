require_relative "helper"

module RubyX
  module Macro
    class TestObjectExit < MiniTest::Test
      include MacroHelper
      def source
        <<GET
        class Object
          def exit(at)
            X.exit
          end
        end
GET
      end
      def test_mom_meth
        assert_equal :exit , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.mom_instructions.length
      end
      def test_instr_get
        assert_equal Mom::Exit , compiler.mom_instructions.next.class
      end
      def test_risc
        assert_equal 40 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
