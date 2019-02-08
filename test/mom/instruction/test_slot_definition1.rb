require_relative "helper"

module Mom

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
end
