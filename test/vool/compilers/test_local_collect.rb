require_relative "helper"

module Vool
  module Compilers
    class TestLocalCollect < MiniTest::Test

      def compile(input)
        lst = VoolCompiler.compile( input )
        vars = []
        lst.collect([]).each do |node|
          node.add_local(vars)
        end
        vars
      end

      def test_assign_collect
        vars = compile( "var = 5" )
        assert_equal :var , vars.first
      end

      def test_return_collect
        vars = compile( "var = 5 ; return var" )
        assert_equal :var , vars.first
      end
    end
  end
end
