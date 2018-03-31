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
        assert Positioned.position(obj)
      end
    end

    def test_binary
      @machine.create_binary
    end
  end
end
