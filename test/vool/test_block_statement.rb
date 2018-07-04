
require_relative "helper"

module Vool
  class TestBlockStatement < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @ret = compile_mom( as_test_main("self.main {|elem| elem } "))
    end

    def test_is_compiler
      assert_equal Mom::MomCompiler , @ret.class
    end

    def est_has_compilers
      assert_equal Risc::MethodCompiler , @ret.method_compilers.first.class
    end

  end
end
