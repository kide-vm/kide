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
    def test_label_last_in_binary
      before = get(11)
      assert_equal 52 , Position.get(before).at
      label = Label.new("HI","Ho" , FakeAddress.new(0))
      before.insert( label )
      assert_equal 56 , Position.get(label).at
      label
    end
    def test_after_last_label
      after = get(12)
      label = test_label_last_in_binary
      assert_equal 56 , Position.get(label).at
      assert_equal 56 , Position.get(after).at
      assert_equal label.next , after
    end
    def test_but_last
      assert_equal 56 , Position.get(get(12)).at
    end
    def get(n)
      ins = @instruction
      while( n > 0 )
        ins = ins.next
        n -= 1
      end
      ins
    end
  end
end
