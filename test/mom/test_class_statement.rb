
require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @ret = compile_mom( as_test_main("return 1"))
    end

    def test_return_class
      assert_equal Mom::MomCompiler , @ret.class
    end
    def test_has_compilers
      assert_equal Risc::MethodCompiler , @ret.method_compilers.first.class
    end

    def test_constant
      assert @ret.method_compilers.first.add_constant( Parfait::Integer.new(5) )
    end

  end
end
