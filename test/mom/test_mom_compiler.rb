require_relative "helper"

module Mom
  class TestMomCompiler < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @comp = compile_mom( "class Test ; def main(); return 1; end; end;")
    end

    def test_class
      assert_equal MomCompiler , @comp.class
    end
    def test_compilers
      assert_equal 24 , @comp.method_compilers.length
    end
    def test_has_translate
      assert @comp.translate(:interpreter)
    end
  end
end
