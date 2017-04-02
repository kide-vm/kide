require_relative "helper"

module Vool
  class TestMethodStatement < MiniTest::Test

    def setup
      input = "def tryout(arg1, arg2) ; end "
      @lst = Compiler.compile( input )
    end

    def test_compile_method
      assert_equal MethodStatement , @lst.class
    end

    def test_compile_method_name
      assert_equal :tryout , @lst.name
    end

    def test_compile_method_super
      assert_equal [:arg1, :arg2] , @lst.args
    end

    def test_compile_method_body
      assert_equal [] , @lst.body
    end

  end
end
