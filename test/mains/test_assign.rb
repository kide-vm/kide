require_relative "helper"

module Mains
  class AssignTester < MiniTest::Test
    include MainsHelper

    def test_local
      @input = as_main 'a = 15 ; return a'
      assert_result  15 , ""
    end

    def test_plus
      @preload = "Integer.plus"
      @input = as_main("a = 5 + 5 ; return a")
      assert_result 10 , ""
    end

    def test_plus2
      @preload = "Integer.plus"
      @input = as_main("a = 5 ;a = 5 + a ; return a")
      assert_result 10 , ""
    end

    def test_plus3
      @preload = "Integer.plus"
      @input = as_main("a = 5 ;a = 5 + a ;a = a + 5; return a")
      assert_result 15 , ""
    end

  end
end
