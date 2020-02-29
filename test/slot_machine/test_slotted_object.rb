require_relative "helper"

module SlotMachine

  class TestSlottedObjectType < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc.test_compiler
      @slotted = Slotted.for(Parfait.object_space , [:type])
      register = @slotted.to_register(compiler , InstructionMock.new)
      @instruction = compiler.risc_instructions.next
    end
    def test_def_class
      assert_equal Risc::LoadConstant , @instruction.class
    end
    def test_def_register
      assert @instruction.register.is_object?
    end
    def test_def_const
      assert_equal Parfait::Space , @instruction.constant.class
    end
    def test_to_s
      assert_equal "Space.type" , @slotted.to_s
    end
    def test_def_register2
      reg = @instruction.next.register
      assert reg.is_object?
      assert reg.symbol.to_s.index(".") , reg.symbol.to_s
    end
    def test_def_next_index
      assert_equal 0 , @instruction.next.index
    end
  end
  class TestSlottedObjectType2 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc.test_compiler
      @slotted = Slotted.for(Parfait.object_space , [:type , :type])
      register = @slotted.to_register(compiler , InstructionMock.new)
      @instruction = compiler.risc_instructions.next
    end
    def test_def_register2
      reg = @instruction.next.register
      assert reg.is_object?
      assert_equal "type", reg.symbol.to_s.split(".").last
      assert_equal 2, reg.symbol.to_s.split(".").length
    end
  end
  class TestSlottedObjectType3 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc.test_compiler
      @slotted = Slotted.for(Parfait.object_space , [:type , :type , :type])
      register = @slotted.to_register(compiler , InstructionMock.new)
      @instruction = compiler.risc_instructions.next
    end
    def test_def_register3
      reg = @instruction.next.next.register
      assert reg.is_object?
      assert_equal "type", reg.symbol.to_s.split(".").last
      assert_equal 3, reg.symbol.to_s.split(".").length
    end
  end
end
