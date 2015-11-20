require_relative 'helper'

class TestwordRT < MiniTest::Test
  include ParfaitTests

  def test_len
    @main = <<HERE
Word w = " "
return w.char_length
HERE
    check 1
  end

  def test_set_len
    @main = <<HERE
Word w = " "
w.set_length(2)
return w.char_length
HERE
    check 2
  end

  def test_set_char_len
    @main = <<HERE
Word w = " "
w.set_char_at(1 , 30)
return w.char_length
HERE
    check 1
  end

  def test_set_char_len2
    @main = <<HERE
Word w = " "
w.set_length(2)
w.set_char_at(2 , 30)
return w.char_length
HERE
    check 2
  end

  def test_set_char_len3
    @main = <<HERE
Word w = " "
w.set_length(2)
w.set_char_at(2 , 30)
return w.get_char_at(2)
HERE
    check 30
  end

  def test_set_char_len4
    @main = <<HERE
Word w = " "
w.set_char_at(1 , 20)
w.set_length(2)
return w.get_char_at(1)
HERE
    check 20
  end

  def test_space
    @main = <<HERE
Word w = " "
return w.get_char_at(1)
HERE
    assert_equal 32 , " ".codepoints[0] # just checking
    check 32
  end

  def test_add_doesnt_change1
    @main = <<HERE
Word w = " "
w.push_char(48)
return w.get_char_at(1)
HERE
      check 32
  end

  def test_after_add_get_works
    @main = <<HERE
Word w = " "
w.push_char(48)
return w.get_char_at(2)
HERE
    check 48
  end

  def test_after_add_length_works
    @main = <<HERE
Word w = " "
w.push_char(32)
return w.char_length
HERE
    check 2
  end

  def test_get1
    @main = <<HERE
Word w = "12345"
return w.get_char_at(1)
HERE
    check 49
  end

  def test_get2
    @main = <<HERE
Word w = "12345"
return w.get_char_at(2)
HERE
    check 50
  end

  def test_set2
    @main = <<HERE
Word w = "12345"
w.set_char_at(2 , 51)
return w.get_char_at(2)
HERE
    check 51
  end

  def test_push
    @main = <<HERE
Word w = "1"
w.push_char(56)
return w.get_char_at(2)
HERE
    check 56
  end
  def test_push1
    @main = <<HERE
Word w = "1"
w.push_char(56)
return w.get_char_at(1)
HERE
    check 49
  end
  def test_push_inlined
    @main = <<HERE
Word w = "1"
int index = w.char_length + 1
w.set_length(index)

w.set_char_at(index , 56)

return w.char_length
HERE
    check 2
  end
  def test_push_inlined2
    @main = <<HERE
Word w = "1"
int index = w.char_length + 1
w.set_length(index)

return w.char_length
HERE
    check 2
  end

  def test_push_len
    @main = <<HERE
Word w = "1"
w.push_char(56)
return w.char_length
HERE
    check 2
  end
  def test_push3_len
    @main = <<HERE
Word w = "1"
w.push_char(56)
w.push_char(56)
w.push_char(56)
return w.char_length
HERE
    check 4
  end

  def test_puts_100000
    @main = <<HERE
    int count = 100352 - 352
    Word hello = "Hello there"
    while_plus( count - 1)
      hello.putstring()
      count = count - 1
     end
     return 1
HERE
    check 1
  end
end
