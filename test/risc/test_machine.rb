require_relative "../helper"

module Risc
  class TestMachineObjects < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def test_objects
      objects = @machine.objects
      assert_equal Hash , objects.class
      assert 350 < objects.length
    end
    def test_constant_fail
      assert_raises {@machine.add_constant( 1 )}
    end
    def test_constant
      assert @machine.add_constant( Parfait::Integer.new(5) )
    end
  end
  class TestMachinePositions < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.position_all
    end
    def test_has_positions
      @machine.objects.each do |id,obj|
        assert Position.get(obj)
      end
    end
  end
  class TestMachineInit < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.position_all
      @machine.create_binary
    end
    def test_has_binary
      assert_equal Parfait::BinaryCode , @machine.binary_init.class
    end
    def test_has_jump
      assert_equal "ea0011f4" ,  @machine.binary_init.get_word(1).to_s(16)
    end
    def test_pos_bin
      assert_equal "0x0" ,  Position.get(@machine.binary_init).to_s
    end
    def test_pos_cpu
      assert_equal 12 ,  Position.get(@machine.cpu_init).at
    end
    def test_cpu_at
      assert_equal 3 ,  Position.get(@machine.cpu_init.first).at
    end
    def test_cpu_bin
      assert_equal "0x3ed8" ,  Position.get(Position.get(@machine.cpu_init.first).binary).to_s
    end
    def test_cpu_label
      assert_equal Position::InstructionPosition ,  Position.get(@machine.cpu_init.first).class
    end
  end
end
