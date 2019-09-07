
require_relative "helper"

module Vool
  class TestClassStatementMom < MiniTest::Test
    include MomCompile

    def setup
      @ret = compile_mom( as_test_main("return 1"))
    end

    def test_return_class
      assert_equal Mom::MomCollection , @ret.class
    end
    def test_has_compilers
      assert_equal Mom::MethodCompiler , @ret.method_compilers.first.class
    end

    def test_constant
      assert @ret.method_compilers.first.add_constant( Parfait::Integer.new(5) )
    end

  end
end
