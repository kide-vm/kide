require_relative "../helper"

class TestFrames < MiniTest::Test

  def setup
    @frame = Register.machine.boot.space.first_message.frame
    @type = @frame.get_type
  end

  def test_frame_get_type
    assert_equal Parfait::Type , @type.class
  end

  def test_frame_next_set
    @frame.next_frame = :next_frame
    assert_equal :next_frame , @frame.next_frame
  end

end
