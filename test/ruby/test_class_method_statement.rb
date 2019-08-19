require_relative "helper"

module Ruby
  class TestClassMethodStatement < MiniTest::Test
    include RubyTests

    def test_basic_method
      input = "def self.tryout() ; return true ; end "
      @lst = compile( input )
      assert_equal Ruby::ClassMethodStatement , @lst.class
    end
    def test_method_arg
      input = "def self.tryout(arg) ; arg = true ; return arg ; end "
      @lst = compile( input )
      assert_equal Ruby::ClassMethodStatement , @lst.class
    end
    def test_tos
      input = "def self.tryout(arg) ; arg = true ; return arg ; end "
      @str = compile( input ).to_s
      assert @str.include?("def self.tryou"), @str
      assert @str.include?("arg = true"), @str
    end
  end
  class TestClassMethodStatement2 < MiniTest::Test
    include RubyTests
    def test_body_is_scope_one_statement
      input = "def self.tryout(arg1, arg2) ; a = true  ; end "
      lst = compile( input )
      assert_equal LocalAssignment , lst.body.class
    end
    def test_body_is_scope_zero_statement
      input = "def self.tryout(arg1, arg2) ; arg1 = arg2 ; end "
      lst = compile( input )
      assert_equal LocalAssignment , lst.body.class
    end
  end

  class TestClassMethodStatementTrans < MiniTest::Test
    include RubyTests

    def setup()
      input = "def self.tryout(arg1, arg2) ; a = arg1 ; end "
      @lst = compile( input ).to_vool
    end
    def test_method
      assert_equal Vool::ClassMethodExpression , @lst.class
    end
    def test_method_args
      assert_equal [:arg1, :arg2] , @lst.args
    end
    def test_body_is_scope_zero_statement
      assert_equal Vool::Statements , @lst.body.class
    end
    def test_body_is_scope_zero_statement
      assert_equal Vool::LocalAssignment , @lst.body.first.class
    end
  end
  class TestClassMethodStatementImplicitReturn < MiniTest::Test
    include RubyTests
    def setup()
      input = "def self.tryout(arg1, arg2) ; arg1 ; end "
      @lst = compile( input ).to_vool
    end
    def test_method
      assert_equal Vool::ClassMethodExpression , @lst.class
    end
    def test_method_args
      assert_equal [:arg1, :arg2] , @lst.args
    end
    def test_body_is_scope_zero_statement
      assert_equal Vool::ReturnStatement , @lst.body.class
    end
  end
  class TestClassMethodStatement < MiniTest::Test
    include RubyTests

    def setup()
      input = "def self.tryout(arg1, arg2) ; true ; false ; end "
      @lst = compile( input )
    end
    def test_method
      assert_equal ClassMethodStatement , @lst.class
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
end
