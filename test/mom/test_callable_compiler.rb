require_relative "helper"

module Mom
  class TestCallableCompiler < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @comp = compile_mom( "class Test ; def main(); return 'Hi'; end; end;")
    end

    def test_class
      assert_equal MomCompiler , @comp.class
    end
    def test_compilers
      assert_equal 23 , @comp.compilers.length
    end
    def test_boot_compilers
      assert_equal 22 , @comp.boot_compilers.length
    end
    def test_compilers_bare
      assert_equal 22 , MomCompiler.new.compilers.length
    end
    def test_returns_constants
      assert_equal Array , @comp.constants.class
    end
    def test_has_constant
      assert_equal  "Hi" , @comp.constants[1].to_string
    end
    def test_has_translate
      assert @comp.translate(:interpreter)
    end
    def test_append_class
      assert_equal MomCompiler,  (@comp.append @comp).class
    end
    def test_append_length
      assert_equal 2 ,  @comp.append(@comp).method_compilers.length
    end
  end
end
