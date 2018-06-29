require_relative "helper"

module Vool
  class TestMethodStatement < MiniTest::Test
    include RubyTests

    def basic_setup()
      input = "def tryout(arg1, arg2) ; true ; false ; end "
      @lst = compile( input )
    end
    def test_method
      basic_setup
      assert_equal MethodStatement , @lst.class
    end

    def test_method_name
      basic_setup
      assert_equal :tryout , @lst.name
    end

    def test_method_args
      basic_setup
      assert_equal [:arg1, :arg2] , @lst.args
    end
    def test_basic_body
      basic_setup
      assert_equal ScopeStatement , @lst.body.class
      assert_equal 2 , @lst.body.length
    end
    def test_body_is_scope_one_statement
      input = "def tryout(arg1, arg2) ; a = true  ; end "
      lst = compile( input )
      assert_equal LocalAssignment , lst.body.class
    end
    def test_body_is_scope_zero_statement
      input = "def tryout(arg1, arg2) ; arg1 = arg2 ; end "
      lst = compile( input )
      assert_equal LocalAssignment , lst.body.class
    end
  end
end
