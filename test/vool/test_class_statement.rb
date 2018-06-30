
require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @ins = compile_mom( "class Test ; def main(); return 1; end; end;")
    end

    def test_return
      assert_equal Mom::ClassCompiler , @ins.class
    end
  end
end
