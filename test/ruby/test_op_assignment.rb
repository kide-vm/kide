require_relative "helper"

module Ruby
  module OpAss
    def test_local_name
      assert_equal :foo , @lst.name
    end
    def test_local_value
      assert_equal SendStatement , @lst.value.class
    end
    def test_local_method
      assert_equal :+ , @lst.value.name
    end
    def test_local_receiver
      assert_equal :foo , @lst.value.receiver.name
    end
    def test_local_receiver
      assert_equal 5 , @lst.value.arguments.first.value
    end
  end
  class TestLocalOpAssign < MiniTest::Test
    include OpAss
    include RubyTests
    def setup
      @lst = compile( "foo += 5")
    end
    def test_local_ass
      assert_equal LocalAssignment , @lst.class
    end
  end
  class TestIvarOpAssign < MiniTest::Test
    include OpAss
    include RubyTests
    def setup
      @lst = compile( "@foo += 5")
    end
    def test_ivar_ass
      assert_equal IvarAssignment , @lst.class
    end
  end
end
