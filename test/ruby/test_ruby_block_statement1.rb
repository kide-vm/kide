require_relative "helper"

module Ruby
  class TestBlockReturn < MiniTest::Test
    include RubyTests

    def setup()
      input = "a = plus_one{return 1 } ; return a "
      @lst = compile( input )
    end
    def test_scope
      assert_equal ScopeStatement , @lst.class
    end
    def test_assign
      assert_equal LocalAssignment , @lst.first.class
    end
    def test_assign_right
      assert_equal RubyBlockStatement , @lst.first.value.class
    end
    def test_method_name
      assert_equal :plus_one , @lst.first.value.send.name
    end
    def test_ret
      assert_equal ReturnStatement , @lst.last.class
    end
  end
  class TestBlockReturnSol < MiniTest::Test
    include RubyTests
    def setup()
      input = "a = plus_one{return 1 } ; return a "
      @lst = compile( input ).to_sol
    end
    def test_scope
      assert_equal Sol::ScopeStatement , @lst.class
    end
    def test_assign
      assert_equal Sol::LocalAssignment , @lst.first.class
      assert_equal :a ,  @lst.first.name
    end
    def test_send
      assert_equal Sol::SendStatement , @lst.first.value.class
      assert_equal :plus_one , @lst.first.value.name
    end
    def test_block_arg
      assert_equal Sol::LambdaExpression , @lst.first.value.arguments.first.class
    end
    def test_ret
      assert_equal Sol::ReturnStatement , @lst[1].class
    end
  end
end
