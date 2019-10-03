require_relative "helper"

module Ruby
  class TestAssignmentRuby < MiniTest::Test
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
  class TestAssignmentSolLocal < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo = bar").to_sol
    end
    def test_tos
      assert_equal "foo = self.bar()" , @lst.to_s
    end
    def test_local
      assert_equal Sol::LocalAssignment , @lst.class
    end
    def test_bar
      assert_equal Sol::SendStatement , @lst.value.class
    end
    def test_local_name
      assert_equal :foo , @lst.name
    end
  end
  class TestAssignmentSolInst < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "@foo = bar").to_sol
    end
    def test_tos
      assert_equal "@foo = self.bar()" , @lst.to_s
    end
    def test_instance
      assert_equal Sol::IvarAssignment , @lst.class
    end
    def test_instance_name
      assert_equal :foo , @lst.name
    end
  end
  class TestAssignmentSolConst < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo = 5").to_sol
    end
    def test_const
      assert_equal Sol::IntegerConstant , @lst.value.class
    end
  end
end
