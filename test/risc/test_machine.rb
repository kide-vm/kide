require_relative "helper"

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
  class TestMachineInit < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.translate(:arm)
      @machine.position_all
      @machine.create_binary
    end
    def test_pos_cpu
      assert_equal 0 ,  Position.get(@machine.cpu_init).at
    end
    def test_cpu_at
      assert_equal "0x5714" ,  Position.get(@machine.cpu_init.first).to_s
    end
    def test_cpu_bin
      assert_equal "0x570c" ,  Position.get(Position.get(@machine.cpu_init.first).binary).to_s
    end
    def test_cpu_label
      assert_equal Position::InstructionPosition ,  Position.get(@machine.cpu_init.first).class
    end
    def test_first_binary_jump
      bin = Parfait.object_space.get_init.binary
      assert 0 != bin.get_word(Parfait::BinaryCode.data_length) , "index 0 is 0 #{bin.inspect}"
    end
    def test_second_binary_first
      bin = Parfait.object_space.get_init.binary.next
      assert 0 != bin.get_word(0) , "index 0 is 0 #{bin.inspect}"
    end
  end
end
