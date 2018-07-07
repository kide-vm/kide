require_relative "helper"

module Vool
  class TestIvarAssignmentX < MiniTest::Test
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
end
