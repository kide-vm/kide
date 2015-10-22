require_relative "../helper"


class TestCompat < MiniTest::Test

  def setup
    Register.machine.boot unless Register.machine.booted
  end

  def test_list_create_from_array
    array = [1,2,3]
    list = Register.new_list(array)
    assert_equal array , list.to_a
  end

  def test_word_create_from_string
    string = "something"
    word = Register.new_word(string)
    assert_equal word , Register.new_word(string)
    assert_equal string , word.to_string
  end
end
