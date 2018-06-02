require_relative "helper"

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
