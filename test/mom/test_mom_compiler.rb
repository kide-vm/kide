require_relative "helper"

module Mom
  class TestMomCompiler < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @comp = compile_mom( "class Test ; def main(); return 'Hi'; end; end;")
    end

    def test_class
      assert_equal MomCompiler , @comp.class
    end
    def test_compilers
      assert_equal 24 , @comp.method_compilers.length
    end
    def test_compilers_bare
      assert_equal 23 , MomCompiler.new.method_compilers.length
    end
    def test_returns_constants
      assert_equal Array , @comp.constants.class
    end
    def test_has_constant
      assert_equal  "Hi" , @comp.constants.first.to_string
    end
    def test_has_translate
      assert @comp.translate(:interpreter)
    end
  end
end
