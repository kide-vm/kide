require_relative "helper"

module Mains
  class ConditionalTester < MiniTest::Test
    include MainsHelper

    def test_simple
      @preload = "Integer.ge"
      @input = code("5 >= 5")
      assert_result 1 , ""
    end
    def test_const
      @input = code("10")
      assert_result 1 , ""
    end
    def test_greater
      @preload = "Integer.gt"
      @input = code("5 > 5")
      assert_result 2 , ""
    end
    def test_smaller
      @preload = "Integer.lt"
      @input = code("5 < 5")
      assert_result 2 , ""
    end
    def test_smaller_eq
      @preload = "Integer.le"
      @input = code("5 <= 5")
      assert_result 1 , ""
    end

    def code( cond , tru = "return 1" , fals = "return 2")
      as_main "if(#{cond}) ; #{tru} ; else ; #{fals} ; end"
    end
  end
end
