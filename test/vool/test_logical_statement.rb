require_relative "../helper"

module Vool
  class TestLogical < MiniTest::Test

    def simple
      Compiler.compile( "@a and @b")
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
      lst = Compiler.compile( "@a or @b")
      assert_equal :or , lst.name
    end

    def test_or2
      lst = Compiler.compile( "@a || @b")
      assert_equal :or , lst.name
    end
    def test_and2
      lst = Compiler.compile( "@a && @b")
      assert_equal :and , lst.name
    end
  end
end
