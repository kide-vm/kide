require_relative "../helper"

module Risc
  module Position
    class Dummy
      def padded_length
        4
      end
    end
    class TestObjectListener < MiniTest::Test

      def setup
        @object = Dummy.new
        @dependent = Dummy.new
        @pos = Position.set(@object,0)
        Position.set(@dependent,0)
        @listener = ObjectListener.new(@dependent)
      end
      def test_register
        assert @pos.register_event(:position_changed , @listener)
      end
      def test_no_fire
        @pos.register_event(:position_changed , self)
        @pos = Position.set(@object,0)
        assert_equal 0 , Position.get(@dependent).at
      end
      def test_reset
        @pos.register_event(:position_changed , @listener)
        @pos = Position.set(@object,4)
        assert_equal 4 , Position.get(@dependent).at
      end
    end
  end
end
