require_relative "helper"

module Risc
  class TestCodeListenerFull < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(:interpreter)
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Risc.label("hi","ho")
      @linker.position_all
    end
    def test_listener_after_extend
      CodeListener.init(@binary,:interpreter).set(10)
      @binary.extend_one
      pos = Position.get(@binary.next_code)
      assert_equal CodeListener , pos.event_table[:position_changed].first.class
    end
    def test_valid_pos_for_extended
      @binary.extend_one
      CodeListener.init(@binary,:interpreter).set(10)
      assert Position.get(@binary.next_code).valid?
    end
    def test_extend_sets_next_pos
      CodeListener.init(@binary,:interpreter).set(10)
      @binary.extend_one
      assert Position.get(@binary.next_code).valid?
    end
    def test_extends_creates_jump
      CodeListener.init(@binary,:interpreter).set(10)
      assert_equal 0 , @binary.get_last
      @binary.extend_one
      assert 0 != @binary.get_last
    end
  end
end
