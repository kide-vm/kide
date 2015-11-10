require_relative 'helper'

class TestwordRT < MiniTest::Test
  include RuntimeTests

  def test_len
    @string_input = <<HERE
Word w = " "
return w.char_length
HERE
    check_return 1
  end

  def test_space
    @string_input = <<HERE
Word w = " "
return w.char_at(1)
HERE
    assert_equal 32 , " ".codepoints[0] # just checking
    check_return 32
  end

  def test_add_doesnt_change1
    @string_input = <<HERE
Word w = " "
w.push_char(32)
return w.char_at(1)
HERE
    check_return 32
  end
  def test_after_add_get_works
    @string_input = <<HERE
Word w = " "
w.push_char(32)
return w.char_at(2)
HERE
    check_return 32
  end
  def test_after_add_length_works
    @string_input = <<HERE
Word w = " "
w.push_char(32)
return w.char_length
HERE
    check_return 2
  end
end
