require_relative "helper"

module Ruby
  class TestLogicalX < MiniTest::Test
    include RubyTests

    def simple
      compile( "@a and @b")
    end
    def test_simple
      lst = simple
      assert_equal LogicalStatement , lst.class
    end
    def test_simple_name
      lst = simple
      assert_equal :and , lst.name
    end
    def test_simple_left
      lst = simple
      assert_equal InstanceVariable , lst.left.class
    end
    def test_simple_right
      lst = simple
      assert_equal InstanceVariable , lst.right.class
    end

    def test_or
      lst = compile( "@a or @b")
      assert_equal :or , lst.name
    end

    def test_or2
      lst = compile( "@a || @b")
      assert_equal :or , lst.name
    end
    def test_and2
      lst = compile( "@a && @b")
      assert_equal :and , lst.name
    end
  end
end
