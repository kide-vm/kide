require_relative "helper"

module Risc
  module Position
    # tests that do no require a boot and only test basic positioning
    class TestObjectPosition < MiniTest::Test

      def test_init
        assert ObjectPosition.init(self , -1)
      end
      def test_next_slot
        mov = Arm::ArmMachine.mov(:r1 , :r1)
        position = ObjectPosition.new(mov , 0)
        assert_equal 4, position.next_slot
      end
      def test_has_get_code
        assert_nil ObjectPosition.init(self , -1).get_code
      end
      def pest_creation_ok
        assert ObjectPosition.new(self,0)
      end
      def pest_creation_fail
        assert_raises {Position.new("0")}
      end
      def pest_add
        res = ObjectPosition.new(self,0) + 5
        assert_equal 5 , res
      end
      def pest_sub
        res = ObjectPosition.new(self,0) - 1
        assert_equal -1 , res
      end
      def pest_sub_pos
        res = ObjectPosition.new(self,0) - ObjectPosition.new(self,0)
        assert_equal 0 , res
      end
      def pest_set
        pos = Position.set(self , 5)
        assert_equal 5 , pos.at
      end
      def tet_tos
        assert_equal "0x10" , Position.set(self).to_s
      end
      def pest_reset_ok
        pos = Position.set(self , 5)
        pos = Position.set(self , 10)
        assert_equal 10 , pos.at
      end
      def pest_reset_fail
        Position.set(self , 5)
        assert_raises{Position.set(self , 10000)}
      end
      def pest_raises_set_nil
        assert_raises { Position.set(self,nil)}
      end
      def pest_at
        pos = Position.set(self , 5)
        pos = Position.at(5)
        assert_equal 5 , pos.at
      end
    end
    class TestPositionEvents < MiniTest::Test
      def setup
        @position = ObjectPosition.new(self)
      end
      def pest_has_register
        assert @position.register_event(:position_changed , self)
      end
      def pest_can_unregister
        assert @position.register_event(:position_changed ,self)
        assert @position.unregister_event(:position_changed ,self)
      end
      def pest_fires
        @position.register_event(:position_changed ,self)
        @position.trigger(:position_changed , @position)
        assert_equal @position , @trigger
      end
      def pest_no_fire_after_unregister
        assert @position.register_event(:position_changed ,self)
        assert @position.unregister_event(:position_changed ,self)
        @position.trigger(:position_changed , @position)
        assert_nil @trigger
      end
      def position_changed(pos)
        @trigger = pos
      end
    end
  end
end
