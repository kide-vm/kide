require_relative "../helper"

module Vool
  class TestAssignment < MiniTest::Test

    def test_local
      lst = Compiler.compile( "foo = bar")
      assert_equal LocalAssignment , lst.class
    end
    def test_local_name
      lst = Compiler.compile( "foo = bar")
      assert_equal :foo , lst.name
    end

  end
end
