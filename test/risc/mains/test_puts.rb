require_relative '../helper'

module Mains
  class TestPuts < MainsTest

    def test_say_hi
      hi = "Hello there"
      run_main "'#{hi}'.putstring"
      assert_equal Parfait::Integer , get_return.class
      assert_equal hi.length , get_return.value
      assert_equal hi , @interpreter.stdout
    end
  end
end
