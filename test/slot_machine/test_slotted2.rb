require_relative "helper"

module SlotMachine
  class TestSlotKnown1 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc::FakeCompiler.new
      slotted = SlottedMessage.new(:caller)
      @register = slotted.to_register(compiler , "fake source")
      @instruction = compiler.instructions.first
    end
    def test_def_class
      assert_equal Risc::SlotToReg , @instruction.class
    end
    def test_def_next_class
      assert_equal NilClass , @instruction.next.class
    end
    def test_def_array #from message r0
      assert_equal :r0 , @instruction.array.symbol
    end
    def test_def_register # to next free register r1
      assert_equal :r1 , @register.symbol
    end
    def test_def_index # at caller index 6
      assert_equal 6 , @instruction.index
    end
  end
end
