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
  class TestAssignmentVoolLocal < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo = bar").to_vool
    end
    def test_tos
      assert_equal "foo = self.bar()" , @lst.to_s
    end
    def test_local
      assert_equal Vool::LocalAssignment , @lst.class
    end
    def test_bar
      assert_equal Vool::SendStatement , @lst.value.class
    end
    def test_local_name
      assert_equal :foo , @lst.name
    end
  end
  class TestAssignmentVoolInst < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "@foo = bar").to_vool
    end
    def test_tos
      assert_equal "@foo = self.bar()" , @lst.to_s
    end
    def test_instance
      assert_equal Vool::IvarAssignment , @lst.class
    end
    def test_instance_name
      assert_equal :foo , @lst.name
    end
  end
  class TestAssignmentVoolConst < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "foo = 5").to_vool
    end
    def test_const
      assert_equal Vool::IntegerConstant , @lst.value.class
    end
  end
end
