require_relative "helper"

module Vool
  module Compilers
    class TestIvarCollect < MiniTest::Test

      def compile(input)
        lst = VoolCompiler.compile( input )
        vars = []
        lst.collect([]).each do |node|
          node.add_ivar(vars)
        end
        vars
      end

      def test_instance_collect
        vars = compile( "@var" )
        assert_equal :var , vars.first
      end

      def test_return_collect
        vars = compile( "return @var" )
        assert_equal :var , vars.first
      end

      def test_assign_collect
        vars = compile( "@var = 5" )
        assert_equal :var , vars.first
      end
    end
  end
end
