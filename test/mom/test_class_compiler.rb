require_relative "helper"

module Mom
  class TestClassCompiler < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @comp = compile_mom( "class Test ; def main(); return 1; end; end;")
    end

    def test_class
      assert_equal ClassCompiler , @comp.class
    end
    def test_compilers
      assert_equal 1 , @comp.method_compilers.length
    end
    def test_has_translate
      assert @comp.translate(:interpreter)
    end
    def test_translate_class
      assert_equal Array , @comp.translate(:interpreter).class
    end
    def test_translate_assemblers
      assert_equal Risc::Assembler , @comp.translate(:interpreter).first.class
    end
  end
end
