require_relative 'helper'

module Register
  class TestAssignStatement < MiniTest::Test
    include Statements

    def test_assign_op
      Parfait.object_space.get_main.add_local(:r , :Integer)

      @input    = s(:statements, s(:assignment, s(:name, :r), s(:operator_value, :+, s(:int, 10), s(:int, 1))))

      @expect = [Label, LoadConstant, LoadConstant, OperatorInstruction, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      check
    end

    def test_assign_local
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input =s(:statements, s(:assignment, s(:name, :r), s(:int, 5)))

      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      check
    end

    def test_assign_local_assign
      Parfait.object_space.get_main.add_local(:r , :Integer)

      @input = s(:statements, s(:assignment, s(:name, :r), s(:int, 5)))

      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
    check
    end

    def test_assign_call
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:assignment, s(:name, :r), s(:call, s(:name, :main), s(:arguments))))
      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
                   SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall ,
                   Label, RegisterTransfer, SlotToReg, SlotToReg, SlotToReg, RegToSlot, Label ,
                   FunctionReturn]
      check
    end

    def test_named_list_get
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:assignment, s(:name, :r), s(:int, 5)), s(:return, s(:name, :r)))
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot ,
                 Label, FunctionReturn]
      was = check
      get = was.next(5)
      assert_equal SlotToReg , get.class
      assert_equal 1 + 1, get.index , "Get to named_list index must be offset, not #{get.index}"
    end

    def test_assign_local_int
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:assignment, s(:name, :r), s(:int, 5)) )
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      was = check
      set = was.next(3)
      assert_equal RegToSlot , set.class
      assert_equal 1 + 1, set.index , "Set to named_list index must be offset, not #{set.index}"
    end

    def test_misassign_local
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:assignment, s(:name, :r), s(:string, "5")) )
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_raises {check }
    end

    def test_assign_arg
      Parfait.object_space.get_main.add_argument(:blar , :Integer)
      @input = s(:statements, s(:assignment, s(:name, :blar), s(:int, 5)))
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      was = check
      set = was.next(3)
      assert_equal RegToSlot , set.class
      assert_equal 1 + 1, set.index , "Set to args index must be offset, not #{set.index}"
    end

    def test_misassign_arg
      Parfait.object_space.get_main.add_argument(:blar , :Integer)
      @input = s(:statements, s(:assignment, s(:name, :blar), s(:string, "5")))
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_raises {check }
    end

    def test_arg_get
      # have to define bar externally, just because redefining main. Otherwise that would be automatic
      Parfait.object_space.get_main.add_argument(:balr , :Integer)
      @input = s(:statements, s(:return, s(:name, :balr)))
      @expect =  [Label, SlotToReg, SlotToReg, RegToSlot, Label, FunctionReturn]
      was = check
      get = was.next(2)
      assert_equal SlotToReg , get.class
      assert_equal 1 + 1, get.index , "Get to args index must be offset, not #{get.index}"
    end
  end
end
