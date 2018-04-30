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
      assert_equal "1" ,  @machine.binary_init.get_word(1).to_s(16)
    end
  end
end
