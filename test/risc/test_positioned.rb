require_relative "../helper"

class TestPositioned < MiniTest::Test
  def setup
    Risc.machine.boot unless Risc.machine.booted
  end
  def test_list1
    list = Parfait.new_list([1])
    assert_equal 32 , list.padded_length
  end
  def test_list5
    list = Parfait.new_list([1,2,3,4,5])
    assert_equal 32 , list.padded_length
  end
  def test_type
    type = Parfait::Type.for_hash Parfait.object_space.get_class_by_name(:Object) , {}
    type.set_type( type )
    assert_equal 32 , type.padded_length
  end
  def test_word
    word = Parfait::Word.new(12)
    assert_equal 32 , word.padded_length
  end
  def test_raises_no_init
    assert_raises { Positioned.position(self)}
  end
  def test_raises_set_nil
    assert_raises { Positioned.set_position(self,nil)}
  end
  def test_raises_reset_far
    assert_raises do
      test = TestPosition.new
      test.set_position  0
      test.set_position  12000
    end
  end

  def test_pos_arm
    mov = Arm::ArmMachine.mov  :r1,  128
    mov.set_position(0,0)
  end
end
