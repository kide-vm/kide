require_relative "helper"

module Risc
  # tests that do no require a boot and only test basic positioning
  class TestPosition < MiniTest::Test

    def test_new
      assert Position.new(self , -1)
    end
    def test_next_slot
      mov = Arm::ArmMachine.mov(:r1 , :r1)
      position = Position.new(mov , 0)
      assert_equal 4, position.next_slot
    end
    def test_has_get_code
      assert_nil Position.new(self , -1).get_code
    end
    def test_has_listeners_helper
      assert_equal Array , Position.new(self,-1).position_listeners.class
    end
    def test_listeners_empty
      assert Position.new(self,-1).position_listeners.empty?
    end
    def test_has_listener_helper
      pos = Position.new(self,-1)
      pos.position_listener( self )
      assert_equal 1 , pos.position_listeners.length
    end

    def pest_creation_fail
      assert_raises {Position.new("0")}
    end
    def pest_add
      res = Position.new(self,0) + 5
      assert_equal 5 , res
    end
    def pest_sub
      res = Position.new(self,0) - 1
      assert_equal -1 , res
    end
    def pest_sub_pos
      res = Position.new(self,0) - Position.new(self,0)
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
      @position = Position.new(self)
    end
    def pest_has_register
      assert @position.position_listener( self)
    end
    def pest_can_unregister
      listener = PositionListener.new(self)
      assert @position.position_listener(listener)
      assert @position.unregister_event(:position_changed ,listener)
    end
    def pest_fires
      @position.position_listener(self)
      @position.trigger(:position_changed , @position)
      assert_equal @position , @trigger
    end
    def pest_no_fire_after_unregister
      listener = PositionListener.new(self)
      assert @position.position_listener( listener)
      assert @position.unregister_event(:position_changed ,listener)
      @position.trigger(:position_changed , @position)
      assert_nil @trigger
    end
    def position_changed(pos)
      @trigger = pos
    end
  end
end

module Risc
  class TestMachinePositions < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
    end
    def pest_cpu_init
      @machine.translate(:interpreter)
      @machine.position_all
      assert Position.get @machine.cpu_init
    end
    def pest_cpu_label
      @machine.translate(:interpreter)
      @machine.position_all
      assert Position.get( @machine.cpu_init.label )
    end
    def pest_cpu_first_arm
      @machine.translate(:arm)
      @machine.position_all
      assert Position.get( @machine.cpu_init.first )
    end
    def pest_has_arm_pos
      has_positions(:arm)
    end
    def pest_has_int_pos
      has_positions(:interpreter)
    end
    def has_positions(platform)
      @machine.translate(:arm)
      @machine.position_all
      @machine.objects.each do |id,obj|
        assert Position.get(obj)
      end
    end
    def pest_has_arm_meth
      meth_positions(:arm)
    end
    def pest_has_int_meth
      meth_positions(:interpreter)
    end
    def meth_positions(platform)
      @machine.translate(:arm)
      @machine.position_all
      Parfait.object_space.each_type do |type|
        type.each_method do |method|
          assert Position.get(method.binary)
          assert Position.get(method.cpu_instructions)
        end
      end
    end
  end
end
