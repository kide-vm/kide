require_relative "../helper"

class TestSpace < MiniTest::Test

  def setup
    @machine = Virtual.machine
    @machine.boot
  end
  def test_booted
    assert_equal true , @machine.booted
  end
  def test_machine_space
    assert_equal Parfait::Space , @machine.space.class
  end
  def test_gloabl_space
    assert_equal Parfait::Space , Parfait::Space.object_space.class
  end
  def test_classes
    assert_equal 16 , @machine.space.classes.length
    [:Kernel,:Word,:List,:Message,:Frame,:Layout,:Class,:Dictionary,:Method].each do |name|
      assert @machine.space.classes[name]
    end
  end
  def test_messages
    mess = @machine.space.first_message
    all = []
    while mess
      all << mess
      assert mess.frame
      mess = mess.next_message
    end
    assert_equal all.length , all.uniq.length
    # there is a 5.times in space, but one Message gets created before
    assert_equal  5 + 1 , all.length
  end
end
