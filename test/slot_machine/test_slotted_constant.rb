require_relative "helper"

module SlotMachine

  class TestSlotConstant < MiniTest::Test
    include Risc::HasCompiler
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @slotted = Slotted.for(StringConstant.new("hi") , nil)
      register = @slotted.to_register(@compiler , InstructionMock.new)
    end
    def test_load
      assert_load 1 , Parfait::Word , "id_"
    end
    def test_def_const
      assert_equal "hi" , risc(1).constant.to_string
    end
  end
  class TestSlotConstantType < MiniTest::Test
    include Risc::HasCompiler
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @slotted = Slotted.for(StringConstant.new("hi") , [:type])
      register = @slotted.to_register(@compiler , InstructionMock.new)
    end
    def test_load
      assert_load 1 , Parfait::Word , "id_"
    end
    def test_def_const
      assert_equal "hi" , risc(1).constant.to_string
    end
    def test_to_s
      assert_equal "StringConstant.type" , @slotted.to_s
    end
    def test_def_register2
      assert_slot_to_reg 2 , "id_" , 0 , "id_.0"
    end
  end
end
