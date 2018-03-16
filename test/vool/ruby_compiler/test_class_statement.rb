require_relative "helper"

module Vool
  class TestEmptyClassStatement < MiniTest::Test

    def setup
      input = "class Tryout < Base;end"
      @lst = RubyCompiler.compile( input )
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
      assert_nil @lst.body
    end

  end
  class TestBasicClassStatement < MiniTest::Test
    include CompilerHelper

    def test_compile_one_method
      lst = RubyCompiler.compile( in_Test("@ivar = 4") )
      assert_equal IvarAssignment , lst.body.class
    end
    def test_compile_two_methods
      lst = RubyCompiler.compile( in_Test("false; true;") )
      assert_equal ScopeStatement , lst.body.class
      assert_equal TrueConstant , lst.body.statements[1].class
    end

  end
end
