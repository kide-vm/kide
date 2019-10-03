require_relative "helper"

module Ruby
  class TestReturnStatement < MiniTest::Test
    include RubyTests

    def test_return_const
      lst = compile( "return 1" )
      assert_equal ReturnStatement , lst.class
    end

    def test_return_value
      lst = compile( "return 1" )
      assert_equal 1 , lst.return_value.value
    end

    def test_return_send
      lst = compile( "return foo" )
      assert_equal SendStatement , lst.return_value.class
      assert_equal :foo , lst.return_value.name
    end

  end
  class TestReturnStatementSol < MiniTest::Test
    include RubyTests

    def test_return_const
      lst = compile( "return 1" ).to_sol
      assert_equal Sol::ReturnStatement , lst.class
    end
    def test_return_value
      lst = compile( "return 1" ).to_sol
      assert_equal 1 , lst.return_value.value
    end

    def test_return_send
      lst = compile( "return foo" ).to_sol
      assert_equal Sol::ReturnStatement , lst.class
    end
    def test_return_send3
      lst = compile( "return foo.bar.zoo" ).to_sol
      assert_equal Sol::LocalAssignment , lst.first.class
      assert lst.first.name.to_s.start_with?("tmp_")
    end
    def test_return_send4
      lst = compile( "return foo.bar.zoo" ).to_sol
      assert_equal Sol::ReturnStatement, lst[2].class
      assert_equal :zoo, lst[2].return_value.name
    end
  end
end
