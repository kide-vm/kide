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
  @expect =  [[SaveReturn,LoadConstant] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
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
  @expect =  [[SaveReturn,GetSlot,GetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
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
    @expect =  [[SaveReturn,LoadConstant,GetSlot,SetSlot,GetSlot,GetSlot] ,
                [RegisterTransfer,GetSlot,FunctionReturn]]
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
  @expect =  [[SaveReturn,GetSlot,GetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
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
  @expect =  [[SaveReturn,GetSlot,GetSlot,SetSlot, LoadConstant,
                SetSlot,RegisterTransfer,FunctionCall,GetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end
end
end
