require_relative 'helper'

class TestIfStatement < MiniTest::Test
  include Statements

  def test_if_basic
    @string_input = <<HERE
class Object
  int main()
    if( 10 < 12)
      return 3
    else
      return 4
    end
  end
end
HERE
  @expect =  [[Virtual::MethodEnter,Register::LoadConstant,Register::LoadConstant,
                Register::OperatorInstruction,Register::IsZeroBranch] ,
                [Register::LoadConstant,Register::AlwaysBranch] ,[Register::LoadConstant]  ,[] ,
                [Virtual::MethodReturn]]
  check
  end


  def test_if_small
    @string_input = <<HERE
class Object
  int main()
    if( 10 < 12)
      return 3
    end
  end
end
HERE
  @expect =  [[Virtual::MethodEnter,Register::LoadConstant,Register::LoadConstant,
                Register::OperatorInstruction,Register::IsZeroBranch] ,
                [Register::AlwaysBranch] ,[Register::LoadConstant]  ,[] ,
                [Virtual::MethodReturn]]
  check
  end


  def ttest_call_function
    @string_input = <<HERE
class Object
  int itest(int n)
    return 4
  end

  int main()
    itest(20)
  end
end
HERE
    @expect =  [ [Virtual::MethodEnter,Register::GetSlot,Register::SetSlot,Register::LoadConstant,
                  Register::SetSlot,Register::LoadConstant,Register::SetSlot,Virtual::MethodCall,
                  Register::GetSlot] ,[Virtual::MethodReturn] ]
  check
  end
end
