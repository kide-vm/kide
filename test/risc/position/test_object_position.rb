require_relative "../helper"

module Risc
  module Position
    # tests that do no require a boot and only test basic positioning
    class TestPositionBasic < MiniTest::Test

      def test_creation_ok
        assert ObjectPosition.new(self,0)
      end
      def test_creation_fail
        assert_raises {Position.new("0")}
      end
      def test_add
        res = ObjectPosition.new(self,0) + 5
        assert_equal 5 , res
      end
      def test_sub
        res = ObjectPosition.new(self,0) - 1
        assert_equal -1 , res
      end
      def test_sub_pos
        res = ObjectPosition.new(self,0) - ObjectPosition.new(self,0)
        assert_equal 0 , res
      end
      def test_set
        pos = Position.set(self , 5)
        assert_equal 5 , pos.at
      end
      def tet_tos
        assert_equal "0x10" , Position.set(self).to_s
      end
      def test_reset_ok
        pos = Position.set(self , 5)
        pos = Position.set(self , 10)
        assert_equal 10 , pos.at
      end
      def test_reset_fail
        Position.set(self , 5)
        assert_raises{Position.set(self , 10000)}
      end
      def test_raises_set_nil
        assert_raises { Position.set(self,nil)}
      end
      def test_at
        pos = Position.set(self , 5)
        pos = Position.at(5)
        assert_equal 5 , pos.at
      end
    end
    class TestPositionEvents < MiniTest::Test
      def setup
        @position = ObjectPosition.new(self,0)
      end
      def test_has_register
        assert @position.register_listener(self)
      end
      def test_can_unregister
        assert @position.register_listener(self)
        assert @position.unregister_listener(self)
      end
      def test_fires
        @position.register_listener(self)
        @position.trigger
        assert_equal @position , @trigger
      end
      def test_no_fire_after_unregister
        assert @position.register_listener(self)
        assert @position.unregister_listener(self)
        @position.trigger
        assert_nil @trigger
      end
      def position_changed(pos)
        @trigger = pos
      end
    end
  end
end
