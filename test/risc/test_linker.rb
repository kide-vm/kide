require_relative "helper"

module Risc
  class TestMachineObjects < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(:arm)
    end
    def test_objects
      objects = @linker.object_positions
      assert_equal Hash , objects.class
      assert 350 < objects.length
    end
    def test_constant_fail
      assert_raises {@machine.add_constant( 1 )}
    end
  end
  class TestMachinePos < MiniTest::Test
    def setup
      Parfait.boot!
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(:arm)
      @linker.position_all
    end
    def test_positions_set
      @machine.object_positions.each do |obj , position|
        assert Position.get(obj).valid? , "#{Position.get(obj)} , #{obj.object_id.to_s(16)}"
      end
    end
  end
  class TestMachineInit #< MiniTest::Test
    def setup
      Parfait.boot!
      @machine = Risc.machine.boot
      @machine.translate(:arm)
      @machine.position_all
      @machine.create_binary
    end
    def test_pos_cpu
      assert_equal 0 ,  Position.get(@machine.cpu_init).at
    end
    def test_cpu_at
      assert_equal "0x6034" ,  Position.get(@machine.cpu_init.first).to_s
    end
    def test_cpu_label
      assert_equal Position ,  Position.get(@machine.cpu_init.first).class
    end
    def test_first_binary_jump
      bin = Parfait.object_space.get_init.binary
      assert 0 != bin.get_word(Parfait::BinaryCode.data_length) , "index 0 is 0 #{bin.inspect}"
    end
    def test_second_binary_first
      bin = Parfait.object_space.get_init.binary.next
      assert 0 != bin.get_word(0) , "index 0 is 0 #{bin.inspect}"
    end
    def test_positions_set
      @machine.object_positions.each do |obj,position|
        assert position.valid? , "#{position} , #{obj.object_id.to_s(16)}"
      end
    end

  end
end
