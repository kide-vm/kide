require_relative "helper"

module Risc
  class TestCodeListener < MiniTest::Test
    def setup
      Parfait.boot!
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Risc.label("hi","ho")
    end

    def test_has_init
      pos = CodeListener.init(@binary,:interpreter)
      assert_equal pos, Position.get(@binary)
    end
    def test_init_fail
      assert_raises{ CodeListener.init( @method)}
    end
    def test_init_returns_position
      assert_equal Position , CodeListener.init(@binary , :interpreter).class
    end
    def test_not_init_listner
      pos = CodeListener.init(@binary,:interpreter)
      assert CodeListener == pos.event_table[:position_changed].last.class
    end
    def test_init_listner
      @binary.extend_one
      CodeListener.init(@binary, :interpreter)
      pos = Position.get(@binary)
      assert_equal CodeListener , pos.event_table[:position_changed].first.class
    end
  end
end
