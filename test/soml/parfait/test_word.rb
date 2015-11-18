require_relative 'helper'

class TestwordRT < MiniTest::Test
  include ParfaitTests

  def test_len
    @main = <<HERE
Word w = " "
return w.char_length
HERE
    check_return 1
  end

  def test_space
    @main = <<HERE
Word w = " "
return w.char_at(1)
HERE
    assert_equal 32 , " ".codepoints[0] # just checking
    check_return 32
  end

  def test_add_doesnt_change1
    @main = <<HERE
Word w = " "
w.push_char(48)
return w.char_at(1)
HERE
      check_return 32
  end
  def test_after_add_get_works
    @main = <<HERE
Word w = " "
w.push_char(48)
return w.char_at(2)
HERE
    check_return 48
  end

  def test_after_add_length_works
    @main = <<HERE
Word w = " "
w.push_char(32)
return w.char_length
HERE
    check_return 2
  end

  def test_get1
    @main = <<HERE
Word w = "12345"
return w.char_at(1)
HERE
    check_return 49
  end

  def test_get2
    @main = <<HERE
Word w = "12345"
return w.char_at(2)
HERE
    check_return 50
  end
end
