require_relative "helper"

module Ruby
  class TestArrayX < MiniTest::Test
    include RubyTests

    def test_empty
      lst = compile( "[]")
      assert_equal ArrayStatement , lst.class
    end
    def test_one
      lst = compile( "[1]")
      assert_equal ArrayStatement , lst.class
    end
    def test_two
      lst = compile( "[1,2]")
      assert_equal ArrayStatement , lst.class
    end
  end
end
