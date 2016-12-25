require_relative 'helper'

module Register
class TestAssignStatement < MiniTest::Test
  include Statements

  def test_assign_op
    Register.machine.space.get_main.add_local(:r , :Integer)

    @input    = s(:statements, s(:assignment, s(:name, :r), s(:operator_value, :+, s(:int, 10), s(:int, 1))))

    @expect = [Label, LoadConstant, LoadConstant, OperatorInstruction, SlotToReg, RegToSlot, Label ,
               FunctionReturn]
    check
  end

  def test_assign_local
    Register.machine.space.get_main.add_local(:r , :Integer)
    @input =s(:statements, s(:assignment, s(:name, :r), s(:int, 5)))

    @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
    check
  end

  def test_assign_local_assign
    Register.machine.space.get_main.add_local(:r , :Integer)

    @input = s(:statements, s(:assignment, s(:name, :r), s(:int, 5)))

    @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
  check
  end

  def test_assign_call
    Register.machine.space.get_main.add_local(:r , :Integer)
    @input = s(:statements, s(:assignment, s(:name, :r), s(:call, s(:name, :main), s(:arguments))))
    @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
               RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               SlotToReg, SlotToReg, SlotToReg, RegToSlot, Label, FunctionReturn]
    check
  end

  def test_named_list_get
    Register.machine.space.get_main.add_local(:r , :Integer)
    @input = s(:statements, s(:assignment, s(:name, :r), s(:int, 5)), s(:return, s(:name, :r)))
    @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot ,
               Label, FunctionReturn]
    was = check
    get = was.next(5)
    assert_equal SlotToReg , get.class
    assert_equal 1, get.index , "Get to named_list index must be offset, not #{get.index}"
  end

  def test_assign_int
    Register.machine.space.get_main.add_local(:r , :Integer)
    @input = s(:statements, s(:assignment, s(:name, :r), s(:int, 5)) )
    @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
    was = check
    set = was.next(3)
    assert_equal RegToSlot , set.class
    assert_equal 1, set.index , "Set to named_list index must be offset, not #{set.index}"
  end

  def test_assign_arg
    Register.machine.space.get_main.add_argument(:blar , :Integer)
    @input = s(:statements, s(:assignment, s(:name, :blar), s(:int, 5)))
    @expect =  [Label, LoadConstant, RegToSlot, Label, FunctionReturn]
    was = check
    set = was.next(2)
    assert_equal RegToSlot , set.class
    assert_equal 10, set.index , "Set to args index must be offset, not #{set.index}"
  end

  def test_arg_get
    # have to define bar externally, just because redefining main. Otherwise that would be automatic
    Register.machine.space.get_main.add_argument(:balr , :Integer)
    @input = s(:statements, s(:return, s(:name, :balr)))
    @expect =   [Label, SlotToReg, RegToSlot, Label, FunctionReturn]
    was = check
    get = was.next(1)
    assert_equal SlotToReg , get.class
    assert_equal 1, get.index , "Get to args index must be offset, not #{get.index}"
  end
end
end
