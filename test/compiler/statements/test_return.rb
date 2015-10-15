require_relative 'helper'

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
  @expect =  [[Virtual::MethodEnter,Register::LoadConstant] , [Virtual::MethodReturn]]
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
  @expect =  [[Virtual::MethodEnter,Register::GetSlot] , [Virtual::MethodReturn]]
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
  @expect =  [[Virtual::MethodEnter,Register::LoadConstant, Register::GetSlot] , [Virtual::MethodReturn]]
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
  @expect =  [[Virtual::MethodEnter,Register::GetSlot] , [Virtual::MethodReturn]]
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
  @expect =  [[Virtual::MethodEnter,Register::GetSlot,Register::SetSlot, Register::LoadConstant,
                Register::SetSlot,Virtual::MethodCall,Register::GetSlot] , [Virtual::MethodReturn]]
  check
  end
end
