require_relative "helper"

module Ruby
  # other Return tests (standalone?) only test the statement
  # But to get the implicit return, we test the method, as it inserts
  # the implicit return
  class TestMethodStatementRet < MiniTest::Test
    include RubyTests
    def test_single_const
      @lst = compile( "def tryout(arg1, arg2) ; true ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.class
    end
    def test_single_instance
      @lst = compile( "def tryout(arg1, arg2) ; @a ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.class
    end
    def test_single_call
      @lst = compile( "def tryout(arg1, arg2) ; is_true() ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.class
    end

    def test_multi_const
      @lst = compile( "def tryout(arg1, arg2) ; @a = some_call(); true ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.last.class
    end
    def test_multi_instance
      @lst = compile( "def tryout(arg1, arg2) ; @a = some_call(); @a ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.last.class
    end
    def test_multi_call
      @lst = compile( "def tryout(arg1, arg2) ; is_true() ; some_call() ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.last.class
    end

    def test_return
      @lst = compile( "def tryout(arg1, arg2) ; return 1 ; end " ).to_vool
      assert_equal Vool::ReturnStatement , @lst.body.class
      assert_equal Vool::IntegerConstant , @lst.body.return_value.class
    end
    def test_local_assign
      @lst = compile( "def tryout(arg1, arg2) ; a = 1 ; end " ).to_vool
      assert_equal Vool::Statements , @lst.body.class
      assert_equal Vool::ReturnStatement , @lst.body.last.class
      assert_equal Vool::LocalVariable , @lst.body.last.return_value.class
    end
    def test_local_assign
      @lst = compile( "def tryout(arg1, arg2) ; @a = 1 ; end " ).to_vool
      assert_equal Vool::Statements , @lst.body.class
      assert_equal Vool::ReturnStatement , @lst.body.last.class
      assert_equal Vool::InstanceVariable , @lst.body.last.return_value.class
    end
  end
end
