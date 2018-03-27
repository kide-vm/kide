require_relative "../helper"

module Risc
  class TestMachine < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end

    def test_objects
      objects = @machine.objects
      assert_equal Hash , objects.class
      assert 400 < objects.length
    end

    def test_position
      @machine.position_all
      objects = @machine.objects
      assert_equal Hash , objects.class
      assert 400 < objects.length
    end
  end
end
