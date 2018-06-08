require_relative "helper"

module Risc
  class TestInstructionListenerBig < MiniTest::Test
    def setup
      DummyPlatform.boot
      @binary = Parfait::BinaryCode.new(1)
      @bin_pos = CodeListener.init(@binary).set(0)
      @instruction = DummyInstruction.new
      13.times {@instruction.last.insert(DummyInstruction.new) }
      @position = InstructionListener.init(@instruction , @binary)
      @position.set(8)
    end
    def test_padding
      assert_equal 64 , @binary.padded_length
    end
    def test_last
      assert_equal 72 , Position.get(@instruction.last).at
    end
    def test_next
      assert @binary.next
    end
    def test_insert_initializes
      @instruction.insert DummyInstruction.new
      assert Position.get(@instruction.next)
    end
    def test_insert_pushes
      @instruction.insert DummyInstruction.new
      assert_equal 76 , Position.get(@instruction.last).at
    end
    def test_pushes_after_insert
      @instruction.insert DummyInstruction.new
      @position.set(12)
      assert_equal 80 , Position.get(@instruction.last).at
    end
  end
end
