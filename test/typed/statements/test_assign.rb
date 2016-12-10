require_relative 'helper'

module Register
class TestAssignStatement < MiniTest::Test
  include Statements

  def setup
    Register.machine.boot
  end

  def _test_assign_op
    @input    =   s(:statements, s(:field_def, :Integer, s(:name, :n),
                                  s(:operator_value, :+, s(:int, 10), s(:int, 1))))

    @expect = [Label, LoadConstant, LoadConstant, OperatorInstruction, GetSlot, SetSlot, Label ,
               FunctionReturn]
    check
  end

  def _test_assign_local
    @input =  s(:statements, s(:field_def, :Integer, s(:name, :runner)),
                      s(:assignment, s(:name, :runner), s(:int, 5)))

    @expect =  [Label, LoadConstant, GetSlot, SetSlot, Label, FunctionReturn]
    check
  end

  def _test_assign_local_assign
    @input = <<HERE
class Space
  int main()
    int runner = 5
  end
end
HERE
    @expect =  [Label, LoadConstant, GetSlot, SetSlot, Label, FunctionReturn]
  check
  end

  def _test_assign_call
    @input = <<HERE
class Space
  int main()
    int r = main()
  end
end
HERE
    @expect = [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
    check
  end

  def _test_frame_get
    @input = <<HERE
class Space
  int main()
    int r = 5
    return r
  end
end
HERE
    @expect =  [Label, LoadConstant, GetSlot, SetSlot, GetSlot, GetSlot, SetSlot ,
               Label, FunctionReturn]
    was = check
    get = was.next(5)
    assert_equal GetSlot , get.class
    assert_equal 4, get.index , "Get to frame index must be offset, not #{get.index}"
  end

  def _test_assign_int
    @input = <<HERE
class Space
  int main()
    int r = 5
  end
end
HERE
    @expect =  [Label, LoadConstant, GetSlot, SetSlot, Label, FunctionReturn]
    was = check
    set = was.next(3)
    assert_equal SetSlot , set.class
    assert_equal 4, set.index , "Set to frame index must be offset, not #{set.index}"
  end

  def _test_assign_arg
    Register.machine.space.get_main.arguments.push Parfait::Variable.new(:Integer , :blar)
    @input = <<HERE
class Space
  int main(int blar)
    blar = 5
  end
end
HERE
    @expect =  [Label, LoadConstant, SetSlot, Label, FunctionReturn]
    was = check
    set = was.next(2)
    assert_equal SetSlot , set.class
    assert_equal 10, set.index , "Set to args index must be offset, not #{set.index}"
  end

  def _test_arg_get
    # have to define bar externally, just because redefining main. Otherwise that would be automatic
    Register.machine.space.get_main.arguments.push Parfait::Variable.new(:Integer , :balr)
    @input = <<HERE
class Space
  int main(int balr)
    return balr
  end
end
HERE
    @expect =   [Label, GetSlot, SetSlot, Label, FunctionReturn]
    was = check
    get = was.next(1)
    assert_equal GetSlot , get.class
    assert_equal 10, get.index , "Get to frame index must be offset, not #{get.index}"
  end
end
end
