require_relative "helper"

module Parfait
  class TestEmptyWord < ParfaitTest

    def setup
      Parfait.boot!
      @word = Parfait::Word.new(0)
    end
    def test_word_create
      assert @word.empty?
    end
    def test_empty_is_zero
      assert_equal 0 , @word.length
    end
    def test_empty_is_zero_internal
      assert_equal 0 , @word.char_length
    end
    def test_index_check_get
      assert_raises RuntimeError do
        @word.get_char(0)
      end
    end
    def test_index_check_set
      assert_raises RuntimeError do
        @word.set_char(1 , 32)
      end
    end
  end
end
