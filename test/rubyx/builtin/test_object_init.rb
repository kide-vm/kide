require_relative "helper"

module RubyX
  module Builtin
    class TestObjectInit < MiniTest::Test
      include BuiltinHelper
      def source
        <<GET
        class Space
          def main(arg)
            return
          end
        end
        class Object
          def __init(at)
            X.__init
          end
        end
GET
      end
      def test_mom_meth
        assert_equal :__init , compiler.callable.name
      end
      def test_instr_len
        assert_equal 7 , compiler.mom_instructions.length
      end
      def test_instr_get
        assert_equal Mom::Init , compiler.mom_instructions.next.class
      end
      def test_risc
        assert_equal 31 , compiler.to_risc.risc_instructions.length
      end
    end
  end
end
