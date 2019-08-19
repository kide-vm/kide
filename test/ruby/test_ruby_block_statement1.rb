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
  class TestBlockReturnVool < MiniTest::Test
    include RubyTests
    def setup()
      input = "a = plus_one{return 1 } ; return a "
      @lst = compile( input ).to_vool
    end
    def test_scope
      assert_equal Vool::ScopeStatement , @lst.class
    end
    def test_first
      assert_equal Vool::Statements , @lst.first.class
    end
    def test_block_assign
      assert_equal Vool::LocalAssignment , @lst.first.first.class
      assert @lst.first.first.name.to_s.start_with?("implicit_block")
    end
    def test_block_assign_right
      assert_equal Vool::BlockStatement , @lst.first.first.value.class
    end
    def test_a_assign
      assert_equal Vool::LocalAssignment , @lst.first.last.class
      assert_equal :a , @lst.first.last.name
    end
    def test_a_assign_val
      assert_equal Vool::SendStatement , @lst.first.last.value.class
      assert_equal :plus_one , @lst.first.last.value.name
    end
    def test_ret
      assert_equal Vool::ReturnStatement , @lst.last.class
    end
  end
end
