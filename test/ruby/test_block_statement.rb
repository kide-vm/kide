require_relative "helper"

module Ruby
  class TestBlockStatement < MiniTest::Test
    include RubyTests

    def setup()
      input = "plus_one{|arg1| arg1 + 1 } "
      @lst = compile( input )
    end
    def test_block
      assert_equal BlockStatement , @lst.class
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
end
