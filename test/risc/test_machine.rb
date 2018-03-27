require_relative "../helper"

module Risc
  class TestMachine < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def test_objects
      objects = @machine.objects
      assert_equal Hash , objects.class
      assert 350 < objects.length
    end
    def test_position_length
      @machine.position_all
      objects = @machine.objects
      assert_equal Hash , objects.class
      assert 350 < objects.length
    end
    def test_has_positions
      @machine.position_all
      @machine.objects.each do |id,obj|
        assert Positioned.position(obj)
      end
    end
    def test_binary
      @machine.position_all
      @machine.create_binary
    end
  end
end
