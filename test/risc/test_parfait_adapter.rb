require_relative "helper"

module Parfait
  class TestAdapter < MiniTest::Test

    def setup
      Risc.machine.boot
    end

    def test_list_create_from_array
      array = [1,2,3]
      list = Parfait.new_list(array)
      assert_equal array , list.to_a
    end

    def test_word_create_from_string
      string = "something"
      word = Parfait.new_word(string)
      assert_equal word , Parfait.new_word(string)
      assert_equal string , word.to_string
    end
  end
end
