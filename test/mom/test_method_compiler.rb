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
      assert_equal 1 , @comp.method_compilers.length
    end
    def test_has_translate
      assert @comp.translate(:interpreter)
    end
  end
  class TestMomCompilerTranslate < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @comp = compile_mom( "class Test ; def main(); return 1; end; end;")
      @trans = @comp.translate(:interpreter)
    end

    def test_translate_class
      assert_equal Array , @trans.class
    end
    def test_translate_assemblers
      assert_equal Risc::Assembler , @trans.first.class
    end
    def test_assembler_code
      assert_equal Risc::Label , @trans.first.instructions.class
    end
    def test_assembler_assembled
      assert_equal Risc::LoadConstant , @trans.first.instructions.next.class
    end
  end
end
