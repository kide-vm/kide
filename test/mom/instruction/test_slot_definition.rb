require_relative "helper"

module Mom
  class TestSlotDefinitionBasics < MiniTest::Test

    def slot(slot = :caller)
      SlotDefinition.new(:message , slot)
    end
    def test_create_ok1
      assert_equal :message , slot.known_object
    end
    def test_create_ok2
      assert_equal Array , slot.slots.class
      assert_equal :caller , slot.slots.first
    end
    def test_create_fail_none
      assert_raises {slot(nil)}
    end
  end
  class TestSlotDefinitionConstant < MiniTest::Test
    def setup
      Risc.machine.boot
      @compiler = CompilerMock.new
      @definition = SlotDefinition.new(StringConstant.new("hi") , [])
      @instruction = @definition.to_register(@compiler , InstructionMock.new)
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
  end
  class TestSlotDefinitionKnown1 < MiniTest::Test
    def setup
      Risc.machine.boot
      @compiler = CompilerMock.new
      @definition = SlotDefinition.new(:message , :caller)
      @instruction = @definition.to_register(@compiler , InstructionMock.new)
    end
    def test_def_class
      assert_equal Risc::SlotToReg , @instruction.class
    end
    def test_def_array
      assert_equal :r0 , @instruction.array.symbol
    end
    def test_def_register
      assert_equal :r1 , @instruction.register.symbol
    end
  end
end
