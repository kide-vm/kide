require_relative "helper"

module Ruby
  class TestLocalAssignmentX < MiniTest::Test
    include RubyTests

    def test_local
      lst = compile( "foo = bar")
      assert_equal LocalAssignment , lst.class
    end
    def test_local_name
      lst = compile( "foo = bar")
      assert_equal :foo , lst.name
    end
    def test_local_const
      lst = compile( "foo = 5")
      assert_equal LocalAssignment , lst.class
    end
    def test_local_ivar
      lst = compile( "foo = @iv")
      assert_equal LocalAssignment , lst.class
      assert_equal InstanceVariable , lst.value.class
    end

  end
end
