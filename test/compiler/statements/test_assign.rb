require_relative 'helper'

module Register
class TestAssignStatement < MiniTest::Test
  include Statements

  def setup
    Register.machine.boot
  end

  def test_assign_op
    @string_input    = <<HERE
class Object
int main()
  int n =  10 + 1
end
end
HERE
    @expect = [Label, SaveReturn,LoadConstant,LoadConstant,OperatorInstruction,GetSlot,SetSlot,
                Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end

  def test_assign_local
    @string_input = <<HERE
class Object
  int main()
    int runner
    runner = 5
  end
end
HERE
  @expect =  [Label, SaveReturn,LoadConstant,GetSlot,SetSlot ,Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_assign_local_assign
    @string_input = <<HERE
class Object
  int main()
    int runner = 5
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant, GetSlot,SetSlot ,Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_assign_call
    @string_input = <<HERE
class Object
  int main()
    int r = main()
  end
end
HERE
  @expect =  [Label, SaveReturn,GetSlot,GetSlot,SetSlot, LoadConstant,SetSlot,
                  RegisterTransfer,FunctionCall,GetSlot,GetSlot,SetSlot ,
                  Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_frame_get
    @string_input = <<HERE
class Object
  int main()
    int r = 5
    return r
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant,GetSlot,SetSlot,GetSlot,GetSlot ,
                Label,RegisterTransfer,GetSlot,FunctionReturn]
    was = check
    get = was.next(6)
    assert_equal GetSlot , get.class
    assert_equal 3, get.index , "Get to frame index must be offset, not #{get.index}"
  end

  def test_assign_arg
    Register.machine.space.get_main.arguments.push Parfait::Variable.new(:Integer , :bar)
    @string_input = <<HERE
class Object
  int main(int bar)
    bar = 5
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant,SetSlot ,Label,RegisterTransfer,GetSlot,FunctionReturn]
    was = check
    set = was.next(3)
    assert_equal SetSlot , set.class
    assert_equal 9, set.index , "Set to args index must be offset, not #{set.index}"
  end

  def test_assign_int
    @string_input = <<HERE
class Object
  int main()
    int r = 5
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant,GetSlot,SetSlot ,Label,RegisterTransfer,GetSlot,FunctionReturn]
    was = check
    set = was.next(4)
    assert_equal SetSlot , set.class
    assert_equal 3, set.index , "Set to frame index must be offset, not #{set.index}"
  end

  def test_arg_get
    # have to define bar externally, just because redefining main. Otherwise that would be automatic
    Register.machine.space.get_main.arguments.push Parfait::Variable.new(:Integer , :bar)
    @string_input = <<HERE
class Object
  int main(int bar)
    return bar
  end
end
HERE
    @expect =  [Label, SaveReturn,GetSlot , Label , RegisterTransfer,GetSlot,FunctionReturn]
    was = check
    get = was.next(2)
    assert_equal GetSlot , get.class
    assert_equal 9, get.index , "Get to frame index must be offset, not #{get.index}"
  end
end
end
