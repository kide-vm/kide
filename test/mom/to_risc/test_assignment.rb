
require_relative 'helper'

module Risc
  class TestAssignStatement < MiniTest::Test
    include Statements

    def test_assign_local_assign
      Parfait.object_space.get_main.add_local(:r , :Integer)

      @input = "r = 5"

      @expect = [LoadConstant, RegToSlot]

      assert_nil msg = check_nil , msg
    end


    def pest_assign_op
      Parfait.object_space.get_main.add_local(:r , :Integer)

      @input    = "r = 10.mod4"

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def pest_assign_ivar_notpresent
      @input = "@r = 5"
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def pest_assign_ivar
      add_space_field(:r , :Integer)

      @input =s(:statements, s(:i_assignment, s(:ivar, :r), s(:int, 5)))

      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def pest_assign_call
      Parfait.object_space.get_main.add_local(:r , :Object)
      @input = s(:statements, s(:l_assignment, s(:local, :r), s(:call, :main, s(:arguments))))
      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
               LoadConstant, SlotToReg, RegToSlot, LoadConstant, RegToSlot, RiscTransfer ,
               FunctionCall, Label, RiscTransfer, SlotToReg, SlotToReg, SlotToReg ,
               RegToSlot, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def pest_named_list_get
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:l_assignment, s(:local, :r), s(:int, 5)), s(:return, s(:local, :r)))
      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      was = check_return
      get = was.next(5)
      assert_equal SlotToReg , get.class
      assert_equal 1 + 1, get.index , "Get to named_list index must be offset, not #{get.index}"
    end

    def pest_assign_local_int
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:l_assignment, s(:local, :r), s(:int, 5)) )
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      was = check_return
      set = was.next(3)
      assert_equal RegToSlot , set.class
      assert_equal 1 + 1, set.index , "Set to named_list index must be offset, not #{set.index}"
    end

    def pest_misassign_local
      Parfait.object_space.get_main.add_local(:r , :Integer)
      @input = s(:statements, s(:l_assignment, s(:local, :r), s(:string, "5")) )
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_raises {check }
    end

    def pest_assign_arg
      Parfait.object_space.get_main.add_argument(:blar , :Integer)
      @input = s(:statements, s(:a_assignment, s(:arg, :blar), s(:int, 5)))
      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      was = check_return
      set = was.next(3)
      assert_equal RegToSlot , set.class
      assert_equal 1 + 1, set.index , "Set to args index must be offset, not #{set.index}"
    end

    def pest_misassign_arg
      Parfait.object_space.get_main.add_argument(:blar , :Integer)
      @input = s(:statements, s(:a_assignment, s(:arg, :blar), s(:string, "5")))
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_raises {check }
    end

    def pest_arg_get
      # have to define bar externally, just because redefining main. Otherwise that would be automatic
      Parfait.object_space.get_main.add_argument(:balr , :Integer)
      @input = s(:statements, s(:return, s(:arg, :balr)))
      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      was = check_return
      get = was.next(2)
      assert_equal SlotToReg , get.class
      assert_equal 1 + 1, get.index , "Get to args index must be offset, not #{get.index}"
    end
  end
end
