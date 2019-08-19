require_relative "helper"

module Ruby
  class TestBlockStatement < MiniTest::Test
    include RubyTests

    def setup()
      input = "plus_one{|arg1| arg1 + 1 } "
      @lst = compile( input )
    end
    def test_block
      assert_equal RubyBlockStatement , @lst.class
    end
    def test_send
      assert_equal SendStatement , @lst.send.class
    end
    def test_method_name
      assert_equal :plus_one , @lst.send.name
    end
    def test_block_args
      assert_equal [:arg1] , @lst.args
    end
    def test_block_body
      assert_equal SendStatement , @lst.body.class
      assert_equal 1 , @lst.body.arguments.length
    end
  end
  class TestBlockStatementVool < MiniTest::Test
    include RubyTests

    def setup()
      input = "plus_one{|arg1| arg1 + 1 } "
      @lst = compile( input ).to_vool
    end
    def test_block
      assert_equal Vool::Statements , @lst.class
    end
    def test_first
      assert_equal Vool::LocalAssignment , @lst.first.class
      assert @lst.first.name.to_s.start_with?("implicit_block_")
      assert_equal Vool::BlockStatement , @lst.first.value.class
    end
    def test_last_send
      assert_equal 2 , @lst.length
      assert_equal Vool::SendStatement , @lst.last.class
      assert_equal :plus_one , @lst.last.name
    end
    def test_send_block_arg
      assert_equal 1 , @lst.last.arguments.length
      assert @lst.last.arguments.first.name.to_s.start_with?("implicit_block_")
    end
    def test_block_args
      assert_equal [:arg1] , @lst.first.value.args
    end
  end
end
