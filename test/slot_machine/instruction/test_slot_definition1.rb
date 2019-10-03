require_relative "helper"

module SlotMachine

  class TestSlotDefinitionConstant < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc::FakeCompiler.new
      @definition = SlotDefinition.new(StringConstant.new("hi") , [])
      @register = @definition.to_register(@compiler , InstructionMock.new)
      @instruction = @compiler.instructions.first
    end
    def test_def_class
      assert_equal Risc::LoadConstant , @instruction.class
    end
    def test_def_register
      assert_equal :r1 , @instruction.register.symbol
    end
    def test_def_const
      assert_equal "hi" , @instruction.constant.to_string
    end
    def test_to_s
      assert_equal "[StringConstant]" , @definition.to_s
    end
  end
  class TestSlotDefinitionConstantType < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc::FakeCompiler.new
      @definition = SlotDefinition.new(StringConstant.new("hi") , [:type])
      @register = @definition.to_register(@compiler , InstructionMock.new)
      @instruction = @compiler.instructions.first
    end
    def test_def_class
      assert_equal Risc::LoadConstant , @instruction.class
    end
    def test_def_register
      assert_equal :r1 , @instruction.register.symbol
    end
    def test_def_const
      assert_equal "hi" , @instruction.constant.to_string
    end
    def test_to_s
      assert_equal "[StringConstant, type]" , @definition.to_s
    end
    def test_def_register2
      assert_equal :r1 , @compiler.instructions[1].register.symbol
    end
    def test_def_next_index
      assert_equal 0 , @compiler.instructions[1].index
    end
  end
end
