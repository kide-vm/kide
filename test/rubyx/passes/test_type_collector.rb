require_relative "helper"

module Rubyx
  module Passes
    class TestTypeCollector < MiniTest::Test

      def setup
        Risc.machine.boot
      end

      def parse_collect( input )
        ast = Parser::Ruby22.parse input
        TypeCollector.new.collect(ast)
      end

      def test_ivar_name
        hash = parse_collect "def meth; @ivar;end"
        assert hash[:ivar] , hash
      end

      def test_ivar_assign
        hash = parse_collect "def meth; @ivar = 5;end"
        assert hash[:ivar] , hash
      end

      def test_ivar_operator_assign
        hash = parse_collect "def meth; @ivar += 5;end"
        assert hash[:ivar] , hash
      end

      def test_compile_class
        RubyCompiler.compile  "class TestIvar < Object ; def meth; @ivar;end; end"
        itest = Parfait.object_space.get_class_by_name(:TestIvar)
        assert itest
        assert itest.instance_type.names.include?(:ivar) , itest.instance_type.names.inspect
      end

    end
  end
end
