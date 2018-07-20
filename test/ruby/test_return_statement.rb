require_relative "helper"

module Ruby
  class TestReturnStatementVool < MiniTest::Test
    include RubyTests

    def test_return_const
      lst = compile( "return 1" ).to_vool
      assert_equal Vool::ReturnStatement , lst.class
    end
    def test_return_value
      lst = compile( "return 1" ).to_vool
      assert_equal 1 , lst.return_value.value
    end

    def test_return_send
      lst = compile( "return foo" ).to_vool
      assert_equal Vool::LocalAssignment , lst.first.class
    end
    def test_return_send
      lst = compile( "return foo" ).to_vool
      assert lst.last.return_value.name.to_s.start_with?("tmp_")
      assert_equal 2, lst.length
    end
  end
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
end
