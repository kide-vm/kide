require_relative "helper"

module Mom
  module Builtin
    class TestIntOperatorsRisc < BootTest
      def setup
        super
      end
      def each_method &block
        Risc.operators.each do |name|
          method = get_operator_compiler(name)
          block.yield(method)
        end
      end
      def test_compile
        each_method do |method|
          assert_equal Risc::MethodCompiler , method.to_risc.class
        end
      end
      def test_risc_length
        each_method do |method|
          assert_equal 48 , method.to_risc.risc_instructions.length
        end
      end
    end
  end
end
