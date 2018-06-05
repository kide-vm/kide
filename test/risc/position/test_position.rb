require_relative "helper"

module Risc
  # tests that do no require a boot and only test basic positioning
  class TestPosition < MiniTest::Test

    def setup
      @pos = Position.new(self , -1)
    end
    def test_new
      assert @pos
    end
    def test_next_slot
      mov = Arm::ArmMachine.mov(:r1 , :r1)
      position = Position.new(mov , 0)
      assert_equal 4, position.next_slot
    end
    def test_has_get_code
      assert_nil @pos.get_code
    end
    def test_has_listeners_helper
      assert_equal Array , @pos.position_listeners.class
    end
    def test_listeners_empty
      assert @pos.position_listeners.empty?
    end
    def test_has_listener_helper
      @pos.position_listener( self )
      assert_equal 1 , @pos.position_listeners.length
    end
    def test_set
      assert_equal 0 , @pos.set(0)
    end
  end
  class TestPositionMath < MiniTest::Test

    def setup
      @pos = Position.new(self , 5)
    end
    def test_add
      res = @pos + 5
      assert_equal 10 , res
    end
    def test_sub
      res = @pos - 3
      assert_equal 2 , res
    end
    def test_sub_pos
      res = @pos - Position.new(@pos,4)
      assert_equal 1 , res
    end
    def test_tos
      assert_equal "0x5" , @pos.to_s
    end
    def test_reset_ok
      pos = @pos.set(10)
      assert_equal 10 , pos
    end
    def test_at
      pos = Position.at(5)
      assert_equal 5 , pos.at
    end
  end
  class TestPositionEvents < MiniTest::Test
    def setup
      Position.clear_positions
      @instruction = DummyInstruction.new
      @position = Position.new(@instruction , 0)
      @listener = PositionListener.new( @instruction )
    end
    def test_has_register
      assert @position.position_listener( @instruction )
    end
    def test_can_unregister
      listener = PositionListener.new(self)
      assert @position.position_listener(listener)
      assert @position.unregister_event(:position_changed ,listener)
    end
    def pest_fires
      @object = @instruction
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
