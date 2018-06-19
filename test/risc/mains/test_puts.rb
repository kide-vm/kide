require_relative 'helper'

module Mains
  class TestPuts < MainsTest

    def test_say_hi
      hi = "Hello there"
      run_main_return "'#{hi}'.putstring"
      assert_equal hi.length , get_return
      assert_equal hi , @interpreter.stdout
    end
  end
end
