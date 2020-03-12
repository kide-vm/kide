require_relative "helper"

module SlotMachine

  class TestSlottedObjectType < MiniTest::Test
    include Risc::HasCompiler
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @slotted = Slotted.for(Parfait.object_space , slot2)
      register = @slotted.to_register(@compiler , InstructionMock.new)
    end
    def slot2
      [:type]
    end
    def test_load
      assert_load 1 , Parfait::Space , "id_"
    end
    def test_to_s
      assert_equal "Space." + slot2.join(".") , @slotted.to_s
    end
    def test_def_register2
      assert_slot_to_reg 2 , "id_" , 0 , "id_.type"
    end
  end
  class TestSlottedObjectType2 < TestSlottedObjectType
    def slot2
      [:type , :type]
    end
    def test_def_register3
      assert_slot_to_reg 3 , "id_.type" , 0 , "id_.type.type"
    end
  end
  class TestSlottedObjectType3 < TestSlottedObjectType
    def slot2
      [:type , :type , :type ]
    end
    def test_def_register3
      assert_slot_to_reg 4 , "id_.type.type" , 0 , "id_.type.type.type"
    end
  end
end
