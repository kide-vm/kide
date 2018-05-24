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
      assert_equal 1 , @interpreter.clock
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
    def test_tick1
      assert_equal 2 , @interpreter.tick
    end
    def test_clock1
      @interpreter.tick
      assert_equal 2 , @interpreter.clock
    end
    def test_pc1
      @interpreter.tick
      assert_equal 18392 , @interpreter.pc
    end
    def test_tick2
      @interpreter.tick
      assert_equal 3 , @interpreter.tick
    end
    def test_clock2
      @interpreter.tick
      @interpreter.tick
      assert_equal 3 , @interpreter.clock
    end
    def test_pc2
      @interpreter.tick
      @interpreter.tick
      assert_equal 18396 , @interpreter.pc
    end
    def test_tick_15
      15.times {@interpreter.tick}
    end
  end
end
