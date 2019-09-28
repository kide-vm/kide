require_relative "helper"

module Mom
  class TestMomCollection < MiniTest::Test
    include MomCompile

    def setup
      @comp = compile_mom( "class Test ; def main(); return 'Hi'; end; end;")
    end

    def test_class
      assert_equal MomCollection , @comp.class
    end
    def test_compilers
      assert_equal 3 , @comp.compilers.num_compilers
    end
    def test_init_compilers
      assert_equal MomCollection , @comp.init_compilers.class
    end
    def test_compilers_bare
      assert_equal 2 , MomCollection.new.compilers.num_compilers
    end
    def test_append_class
      assert_equal MomCollection,  (@comp.append @comp).class
    end
  end
  class TestMomCollectionToRisc < MiniTest::Test
    include MomCompile

    def setup
      @comp = compile_mom( "class Space ; def main(); return 'Hi'; end; end;")
      @collection = @comp.to_risc()
    end
    def compiler
      @collection.method_compilers.first
    end
    def test_has_to_risc
      assert_equal Risc::RiscCollection, @collection.class
    end
    def test_has_risc_compiler
      assert_equal Risc::MethodCompiler, compiler.class
      assert_equal 3, @collection.method_compilers.length
    end
    def test_has_risc_instructions
      assert_equal Risc::Label, compiler.risc_instructions.class
      assert_equal 13, compiler.risc_instructions.length
    end
  end
end
