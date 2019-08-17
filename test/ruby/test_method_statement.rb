require_relative "helper"

module Ruby
  class TestMethodStatement < MiniTest::Test
    include RubyTests

    def setup()
      input = "def tryout(arg1, arg2) ; true ; false ; end "
      @lst = compile( input )
    end
    def test_method
      assert_equal MethodStatement , @lst.class
    end

    def test_method_name
      assert_equal :tryout , @lst.name
    end
    def test_method_args
      assert_equal [:arg1, :arg2] , @lst.args
    end
    def test_basic_body
      assert_equal ScopeStatement , @lst.body.class
      assert_equal 2 , @lst.body.length
    end
  end
  class TestMethodStatement2 < MiniTest::Test
    include RubyTests
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
