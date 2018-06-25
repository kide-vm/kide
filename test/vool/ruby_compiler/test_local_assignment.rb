require_relative "helper"

module Vool
  class TestLocalAssignment < MiniTest::Test

    def test_local
      lst = RubyCompiler.compile( "foo = bar")
      assert_equal LocalAssignment , lst.class
    end
    def test_local_name
      lst = RubyCompiler.compile( "foo = bar")
      assert_equal :foo , lst.name
    end
    def test_local_const
      lst = RubyCompiler.compile( "foo = 5")
      assert_equal LocalAssignment , lst.class
    end
    def test_local_ivar
      lst = RubyCompiler.compile( "foo = @iv")
      assert_equal LocalAssignment , lst.class
      assert_equal InstanceVariable , lst.value.class
    end

  end
end
