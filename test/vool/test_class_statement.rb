
require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @ret = compile_mom( "class Test ; def main(); return 1; end; end;")
    end

    def test_return_class
      assert_equal Mom::ClassCompiler , @ret.class
    end
    def test_has_compilers
      assert_equal Risc::MethodCompiler , @ret.method_compilers.first.class
    end
  end
end
