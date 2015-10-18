require_relative 'helper'

module Register
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
  @expect =  [[SaveReturn,LoadConstant,LoadConstant,
                OperatorInstruction,IsZeroBranch] ,
                [LoadConstant,AlwaysBranch] ,[LoadConstant]  ,[] ,
                [RegisterTransfer,GetSlot,FunctionReturn]]
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
  @expect =  [[SaveReturn,LoadConstant,LoadConstant,
                OperatorInstruction,IsZeroBranch] ,
                [AlwaysBranch] ,[LoadConstant]  ,[] ,
                [RegisterTransfer,GetSlot,FunctionReturn]]
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
    @expect =  [ [SaveReturn,GetSlot,SetSlot,LoadConstant,
                  SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,
                  GetSlot] ,[RegisterTransfer,GetSlot,FunctionReturn] ]
  check
  end
end
end
