require_relative "helper"

module Risc
  class TestInstructionListenerBig < MiniTest::Test
    def setup
      DummyPlatform.boot
      @binary = Parfait::BinaryCode.new(1)
      @bin_pos = CodeListener.init(@binary, :interpreter).set(0)
      @instruction = DummyInstruction.new
      (bin_length-3).times {@instruction.last.insert(DummyInstruction.new) }
      @position = InstructionListener.init(@instruction , @binary)
      @position.set(8)
    end
    def bin_length
      32
    end
    def test_padding
      assert_equal bin_length*4 , @binary.padded_length
    end
    def test_last
      assert_equal (bin_length*4)+8 , Position.get(@instruction.last).at
    end
    def test_next
      assert @binary.next_code
    end
    def test_insert_initializes
      @instruction.insert DummyInstruction.new
      assert Position.get(@instruction.next)
    end
    def test_insert_pushes
      @instruction.insert DummyInstruction.new
      assert_equal (bin_length*4)+12 , Position.get(@instruction.last).at
    end
    def test_pushes_after_insert
      @instruction.insert DummyInstruction.new
      @position.set(12)
      assert_equal (bin_length*4)+16 , Position.get(@instruction.last).at
    end
    def test_label_last_in_binary
      before = get(bin_length-5)
      assert_equal bin_length*4-12 , Position.get(before).at
      label = Label.new("HI","Ho" , FakeAddress.new(0))
      before.insert( label )
      assert_equal bin_length*4-8 , Position.get(label).at
      label
    end
    def test_after_last_label
      after = get(bin_length-4)
      label = test_label_last_in_binary
      assert_equal bin_length*4-8 , Position.get(label).at
      assert_equal bin_length*4-8 , Position.get(after).at
      assert_equal label.next , after
    end
    def test_but_last
      assert_equal bin_length*4-8 , Position.get(get(bin_length-4)).at
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
