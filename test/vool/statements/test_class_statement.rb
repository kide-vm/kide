require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test

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
      assert_equal [] , @lst.body
    end

  end
end
