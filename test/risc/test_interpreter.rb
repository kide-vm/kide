require_relative "helper"

module Risc
  class TestInterpreterBasics < MiniTest::Test

    def test_class
      assert_equal Risc::Interpreter , Interpreter.new.class
    end
    def test_starts_stopped
      assert_equal :stopped , Interpreter.new.state
    end
    def test_has_regs
      assert_equal 12 , Interpreter.new.registers.length
    end
    def test_has_r0
      assert_equal :r0 , Interpreter.new.registers.keys.first
    end
  end
  class TestInterpreterStarts < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.translate(:interpreter)
      @machine.position_all
      @interpreter = Interpreter.new
    end
    def test_starts
      assert_equal 0 , @interpreter.start_machine
    end
    def test_started
      @interpreter.start_machine
      assert_equal :running , @interpreter.state
    end
    def test_pos
      @interpreter.start_machine
      assert_equal 0 , @interpreter.clock
    end
  end
  class TestInterpreterTicks < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.translate(:interpreter)
      @machine.position_all
      @interpreter = Interpreter.new
      @interpreter.start_machine
    end
    def test_tick
      assert_equal 19484 , @interpreter.tick
    end
    def test_tick
      assert_equal 19484 , @interpreter.tick
      assert_equal 19488 , @interpreter.tick
    end
  end
end
