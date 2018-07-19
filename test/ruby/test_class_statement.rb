require_relative "helper"

module Ruby
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
end
