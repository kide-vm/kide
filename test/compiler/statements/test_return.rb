require_relative 'helper'

module Register
class TestReturnStatement < MiniTest::Test
  include Statements


  def test_return_int
    @string_input = <<HERE
class Object
  int main()
    return 5
  end
end
HERE
    @expect =  [Label, LoadConstant ,SetSlot,Label,RegisterTransfer,GetSlot,FunctionReturn]
    was = check
    set = was.next(2)
    assert_equal SetSlot , set.class
    should = Register.machine.space.first_message.get_layout.variable_index(:return_value)
    assert_equal should, set.index , "Set to message must got to return_value(#{should}), not #{set.index}"
  end

  def test_return_local
    @string_input = <<HERE
class Object
  int main()
    int runner
    return runner
  end
end
HERE
  @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_return_local_assign
    @string_input = <<HERE
class Object
  int main()
    int runner = 5
    return runner
  end
end
HERE
    @expect =  [Label, LoadConstant,GetSlot,SetSlot,GetSlot,GetSlot ,SetSlot,
                Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_return_field
    @string_input = <<HERE
class Object
  field int runner
  int main()
    return self.runner
  end
end
HERE
  @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_return_call
    @string_input = <<HERE
class Object
  int main()
    return main()
  end
end
HERE
    @expect = [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, GetSlot ,
               SetSlot, Label, RegisterTransfer, GetSlot, FunctionReturn]
    check
  end
end
end
