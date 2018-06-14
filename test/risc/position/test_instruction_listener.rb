require_relative "helper"

module Risc
  class TestInstructionListener < MiniTest::Test
    def setup
      Risc.machine.boot
      @binary = Parfait::BinaryCode.new(1)
      @bin_pos = Position.new(@binary,0)
      @instruction = DummyInstruction.new(DummyInstruction.new)
      @position = InstructionListener.init(@instruction , @binary)
    end
    def test_label_address
      label = Label.new("hi" ,"ho" , FakeAddress.new(0))
      label_pos = Position.new( label , -1 )
      label_pos.position_listener(InstructionListener.new(@binary))
      label_pos.set(8)
      assert_equal 8 , label_pos.object.address.value
    end
    def test_init
      assert InstructionListener.init(@instruction , @binary)
    end
    def test_pos_not_set
      assert_equal (-1),  @position.at
    end
    def test_init_fail
      assert_raises {InstructionListener.init(@instruction , nil)}
    end
    def test_init_fail_nil
      assert_raises {InstructionListener.init(nil , @binary)}
    end
    def test_listener_method
      @position.set(8)
      listener = InstructionListener.new( @binary )
      listener.position_changed(@position)
    end
    def test_ins_propagates
      assert_equal (-1) , Position.get(@instruction.next).at
      @position.set( 8 )
      assert_equal 12 , Position.get(@instruction.next).at
    end
    def test_ins_propagates_again
      test_ins_propagates
      @position.set( 12 )
      assert_equal 16 , Position.get(@instruction.next).at
    end
    def test_label_has_no_length
      label = Label.new("Hi","Ho" , FakeAddress.new(5) , @instruction)
      InstructionListener.init(label , @binary)
      Position.get(label).set(12)
      assert_equal 12 , Position.get(@instruction).at
    end
    def test_label_at_branch
      label = Label.new("Hi","Ho" , FakeAddress.new(5) , @instruction)
      branch = Branch.new("b" , label)
      Position.new(label , 8 )
      Position.new(branch , 8 )
      at_8 = Position.at(8)
      assert_equal Position , at_8.class
      assert_equal Branch , at_8.object.class
    end
  end
end
