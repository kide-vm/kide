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
    @expect =  [Label, LoadConstant ,SetSlot,Label,FunctionReturn]
    check 
  end

  def test_return_local
    @string_input = <<HERE
class Object
  int main()
    int runner = 5
    return runner
  end
end
HERE
  @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,FunctionReturn]
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
                Label,FunctionReturn]
    check
  end

  def test_return_field
    @string_input = <<HERE
class Object
  field int runner
  int main()
    runner = 5
    return self.runner
  end
end
HERE
    @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,FunctionReturn]
    check
  end

  def pest_return_space_length # need to add runtime first
    @string_input = <<HERE
class Object

  int main()
    Layout l = space.get_layout()
    return self.runner
  end
end
HERE
  @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,FunctionReturn]
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
    @expect =  [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
    check
  end
end
end
