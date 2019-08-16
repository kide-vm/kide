require_relative "helper"

module Ruby
  class TestVoolCallMulti2 < MiniTest::Test
    include RubyTests

    include RubyTests
    def setup
      @lst = compile( "@foo = a.call(b)").to_vool
    end
    def test_s
      assert_equal "" , @lst.to_s
    end
  end
end
