require_relative "../helper"

class TestPositioning < MiniTest::Test
  def setup
    Register.machine.boot unless Register.machine.booted
  end
  def test_list1
    list = Register.new_list([1])
    list.set_layout( Parfait::Layout.new Object)
    assert_equal 32 , list.word_length
  end
  def test_list5
    list = Register.new_list([1,2,3,4,5])
    list.set_layout( Parfait::Layout.new Object)
    assert_equal 32 , list.word_length
  end
  def test_layout
    layout = Parfait::Layout.new Object
    layout.set_layout( Parfait::Layout.new Object)
    layout.push 5
    assert_equal 32 , layout.word_length
  end
  def test_word
    word = Parfait::Word.new(12)
    assert_equal 32 , word.word_length
  end
end
