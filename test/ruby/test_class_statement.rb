require_relative "helper"

module Ruby
  class TestClassStatementVool < MiniTest::Test
    include RubyTests

    def setup
      input = "class Tryout < Base;def meth; a = 5 ;end; end"
      @vool = compile( input ).to_vool
    end
    def test_class
      assert_equal Vool::ClassStatement , @vool.class
    end
    def test_body
      assert_equal Vool::Statements , @vool.body.class
    end
    def test_compile_class_name
      assert_equal :Tryout , @vool.name
    end
    def test_compile_class_super
      assert_equal :Base , @vool.super_class_name
    end

  end
  class TestEmptyClassStatement < MiniTest::Test
    include RubyTests

    def setup
      input = "class Tryout < Base;end"
      @lst = compile( input )
    end

    def test_compile_class
      assert_equal ClassStatement , @lst.class
    end
    def test_compile_class_name
      assert_equal :Tryout , @lst.name
    end
    def test_compile_class_super
      assert_equal :Base , @lst.super_class_name
    end
    def test_compile_class_body
      assert @lst.body.empty?
    end

  end
  class TestBasicClassStatement < MiniTest::Test
    include ScopeHelper
    include RubyTests

    def test_compile_one_method
      lst = compile( as_test_main("@ivar = 4") )
      assert_equal IvarAssignment , lst.body.first.body.class
    end
    def test_compile_two_stats
      lst = compile( as_test_main("false; true;") )
      assert_equal ScopeStatement , lst.body.first.body.class
      assert_equal TrueConstant , lst.body.first.body.statements[1].class
    end
  end
  class TestClassStatementTransformFail < MiniTest::Test
    include RubyTests

    def test_if
      input = "class Tryout < Base;  false if(true) ; end"
      assert_raises_muted { compile( input ).to_vool}
    end
    def test_instance
      input = "class Tryout < Base;  @var = 5 ; end"
      assert_raises_muted { compile( input ).to_vool}
    end
    def test_wrong_send
      input = "class Tryout < Base;  hi() ; end"
      assert_raises_muted { compile( input ).to_vool}
    end
  end
  class TestClassStatementTransform < MiniTest::Test
    include RubyTests

    def setup
      input = "class Tryout < Base;attr :page ;end"
      @vool = compile( input ).to_vool
    end
    def test_class
      assert_equal Vool::ClassStatement , @vool.class
    end
    def test_body
      assert_equal Vool::Statements , @vool.body.class
    end
    def test_compile_class_name
      assert_equal :Tryout , @vool.name
    end
    def test_compile_class_super
      assert_equal :Base , @vool.super_class_name
    end

  end

end
