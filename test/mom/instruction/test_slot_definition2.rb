require_relative "helper"

module Mom
  class TestSlotDefinitionKnown1 < MiniTest::Test
    def setup
      Parfait.boot!
      @compiler = CompilerMock.new
      @definition = SlotDefinition.new(:message , :caller)
      @instruction = @definition.to_register(@compiler , InstructionMock.new)
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
      assert_equal :r1 , @instruction.register.symbol
    end
    def test_def_index # at caller index 6
      assert_equal 6 , @instruction.index
    end
  end
end
