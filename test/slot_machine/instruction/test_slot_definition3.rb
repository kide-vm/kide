require_relative "helper"

module SlotMachine
  class TestSlotDefinitionKnown2 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc::FakeCompiler.new
      @definition = MessageDefinition.new( [:caller , :type])
      @register = @definition.to_register(@compiler , InstructionMock.new)
    end
    def test_def_next_class
      assert_equal Risc::SlotToReg , @compiler.instructions[1].class
    end
    def test_def_next_next_class
      assert_equal NilClass , @compiler.instructions[2].class
    end
    def test_def_next_index
      assert_equal 0 , @compiler.instructions[1].index
    end
    def test_def_next_register
      assert_equal :r1 , @compiler.instructions[1].register.symbol
    end
    def test_def_next_array
      assert_equal :r1 , @compiler.instructions[1].array.symbol
    end
  end
end
