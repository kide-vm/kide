require_relative "../helper"

module Risc
  # tests that require a boot and test propagation
  class TestPositionBasic < MiniTest::Test
    def setup
      Risc.machine.boot
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Label.new("hi","ho")
    end
    def test_set_bin
      pos = Position.set( @binary , 0 , @method)
      assert_equal Position::CodePosition , pos.class
    end
    def test_type
      pos = Position.set( @binary , 0 , @method)
      assert_equal "Word_Type" , pos.method.for_type.name
    end
    def test_next
      pos = Position.set( @binary , 0 , @method)
      type = pos.next_type(pos.method.for_type)
      assert_equal "Integer_Type" , type.name
    end
  end
  class TestPositionTranslated < MiniTest::Test
    def setup
      machine = Risc.machine.boot
      machine.translate(:interpreter)
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Label.new("hi","ho")
    end

    def test_bin_propagates_existing
      @binary.extend_to(16)
      Position.set( @binary , 0 , @method)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
    def test_bin_propagates_after
      Position.set( @binary , 0 , Parfait.object_space.get_main)
      @binary.extend_to(16)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
  end
end
