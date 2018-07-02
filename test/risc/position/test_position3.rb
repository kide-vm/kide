require_relative "helper"

module Risc
  class TestMachinePositions < MiniTest::Test
    def setup_for(platform)
      Parfait.boot!
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(platform)
      @linker.position_all
    end
    def test_cpu_init
      setup_for(:interpreter)
#TODO      assert Position.get @linker.cpu_init
    end
    def test_cpu_label
      setup_for(:interpreter)
#TODO      assert Position.get( @linker.cpu_init.label )
    end
    def test_label_positions_match
      setup_for(:interpreter)
      Position.positions.each do |object , position|
        next unless object.is_a?(Label) and  object.next
        assert_equal position.at , Position.get(object.next).at
      end
    end
    def test_cpu_first_arm
      setup_for(:arm)
#TODO      assert Position.get( @linker.cpu_init.first )
    end
    def test_has_arm_pos
      has_positions(:arm)
    end
    def test_has_int_pos
      has_positions(:interpreter)
    end
    def has_positions(platform)
      setup_for(platform)
      @linker.object_positions.each do |obj , pos|
        assert Position.get(obj)
      end
    end
    def test_has_arm_meth
      meth_positions(:arm)
    end
    def test_has_int_meth
      meth_positions(:interpreter)
    end
    def meth_positions(platform)
      setup_for(platform)
      Parfait.object_space.each_type do |type|
        type.each_method do |method|
          assert Position.get(method.binary)
        end
      end
      @linker.assemblers.each do |asm|
        assert Position.get(asm.instructions)
      end
    end
  end
end
