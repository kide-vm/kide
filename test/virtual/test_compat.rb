require_relative "../helper"


class TestCompat < MiniTest::Test

  def test_list_create_from_array
    array = [1,2,3]
    list = Virtual.new_list(array)
    assert_equal list , Virtual.new_list(array)
    assert_equal array , list.to_a
  end

  def test_word_create_from_string
    string = "something"
    word = Virtual.new_word(string)
    assert_equal word , Virtual.new_word(string)
    assert_equal string , word.to_s
  end
end
