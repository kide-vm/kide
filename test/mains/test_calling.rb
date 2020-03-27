require_relative "helper"

module Mains
  class CallTester < MiniTest::Test
    include MainsHelper

    def test_plus
      @preload = "Integer.plus"
      @input = as_main("return 5 + 5")
       assert_result 10 , ""
    end
    def test_minus
      @preload = "Integer.minus"
      @input = as_main("return 6 - 5")
       assert_result 1 , ""
    end
    def test_mult
      @preload = "Integer.mul"
      @input = as_main "return #{2**31} * #{2**31}"
      assert_result 0 , ""
    end
    def test_div
      @preload = "Integer.div10"
      @input = as_main "return 25.div10"
      assert_result 2 , ""
    end
    def test_mod
      @preload = "Integer.div4"
      @input = as_main "return 9.div4"
      assert_result 2 , ""
    end

    def test_puts
      @preload = "Word.put"
      @input = as_main(" return 'Hello again'.putstring ")
      assert_result 11 , "Hello again"
    end

    #FIXME these next two are broken due to a logic error
    # with indexes. Interpreter uses get_char, not get_internal_byte to
    # make it look as if. but no. index haas to be adjusted, or logic changed
    def est_get_byte
      @preload = "Word.get_byte"
      @input = as_main("return 'Hello'.get_internal_byte(0)")
      assert_result "H".ord , ""
    end
    def est_set_byte
      @preload = "Word.set_byte"
      @input = as_main("return 'Hello'.set_internal_byte(0,75)")
      assert_result "K".ord , ""
    end

  end
end
