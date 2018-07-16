require_relative "helper"

module Mom
  class TestSlotDefinitionKnown2 < MiniTest::Test
    def setup
      Parfait.boot!
      @compiler = Risc::FakeCompiler.new
      @definition = SlotDefinition.new(:message , [:caller , :type])
      @instruction = @definition.to_register(@compiler , InstructionMock.new)
    end
    def test_def_next_class
      assert_equal Risc::SlotToReg , @instruction.next.class
    end
    def test_def_next_next_class
      assert_equal NilClass , @instruction.next.next.class
    end
    def test_def_next_index
      assert_equal 0 , @instruction.next.index
    end
    def test_def_next_register
      assert_equal :r1 , @instruction.next.register.symbol
    end
    def test_def_next_array
      assert_equal :r1 , @instruction.next.array.symbol
    end
  end
end
