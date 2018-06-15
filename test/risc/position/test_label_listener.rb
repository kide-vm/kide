require_relative "helper"

module Risc
  class TestLabelListener < MiniTest::Test

    def setup
      Risc.machine.boot
      @label = Label.new("Hi","Ho" , FakeAddress.new(5))
      @label_pos = Position.new(@label ).set(4)
      @code = Parfait::BinaryCode.new(1)
      @code_pos = Position.new(@code)
      @code_pos.position_listener( LabelListener.new(@label))
    end

    def test_move
      @code_pos.set(0)
      assert_equal 8 ,  @label_pos.at
    end
    def test_move_twice
      @code_pos.set(0)
      @code_pos.set(0x40)
      assert_equal 72 ,  @label_pos.at
    end
  end
end
