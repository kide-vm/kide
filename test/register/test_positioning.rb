require_relative "../helper"

class TestPosition
  include Positioned
end

class TestPositioning < MiniTest::Test
  def setup
    Register.machine.boot unless Register.machine.booted
  end
  def test_list1
    list = Parfait.new_list([1])
    list.set_type( Parfait::Type.new Object)
    assert_equal 32 , list.padded_length
  end
  def test_list5
    list = Parfait.new_list([1,2,3,4,5])
    list.set_type( Parfait::Type.new Object)
    assert_equal 32 , list.padded_length
  end
  def test_type
    type = Parfait::Type.new Object
    type.set_type( Parfait::Type.new Object)
    type.push 5
    assert_equal 32 , type.padded_length
  end
  def test_word
    word = Parfait::Word.new(12)
    assert_equal 32 , word.padded_length
  end
  def test_raises_no_init
    assert_raises { TestPosition.new.position}
  end
  def test_raises_set_nil
    assert_raises { TestPosition.new.set_position  nil}
  end
  def test_raises_reset_far
    assert_raises do
      test = TestPosition.new
      test.set_position  0
      test.set_position  12000
    end
  end
end
