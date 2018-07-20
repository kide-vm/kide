require_relative "helper"

module Ruby
  class TestAssignment < MiniTest::Test
    include RubyTests

    def test_local
      lst = compile( "foo = bar")
      assert_equal LocalAssignment , lst.class
    end
    def test_local_name
      lst = compile( "foo = bar")
      assert_equal :foo , lst.name
    end
    def test_instance
      lst = compile( "@foo = bar")
      assert_equal IvarAssignment , lst.class
    end
    def test_instance_name
      lst = compile( "@foo = bar")
      assert_equal :foo , lst.name
    end
    def test_const
      lst = compile( "@foo = 5")
      assert_equal IvarAssignment , lst.class
    end
  end
  class TestAssignmentVool < MiniTest::Test
    include RubyTests

    def test_local
      lst = compile( "foo = bar").to_vool
      assert_equal Vool::LocalAssignment , lst.class
    end
    def test_local_name
      lst = compile( "foo = bar").to_vool
      assert_equal :foo , lst.name
    end
    def test_instance
      lst = compile( "@foo = bar").to_vool
      assert_equal Vool::IvarAssignment , lst.class
    end
    def test_instance_name
      lst = compile( "@foo = bar").to_vool
      assert_equal :foo , lst.name
    end
    def test_const
      lst = compile( "@foo = 5").to_vool
      assert_equal Vool::IvarAssignment , lst.class
    end
  end
end
