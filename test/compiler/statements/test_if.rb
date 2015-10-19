require_relative 'helper'

module Register
class TestIfStatement < MiniTest::Test
  include Statements

  def test_if_basic
    @string_input = <<HERE
class Object
  int main()
    if_plus( 10 - 12)
      return 3
    else
      return 4
    end
  end
end
HERE
  @expect =  [[SaveReturn,LoadConstant,LoadConstant,
                OperatorInstruction,IsPlus] ,
                [LoadConstant,Branch] ,[LoadConstant]  ,[] ,
                [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end


  def test_if_small_minus
    @string_input = <<HERE
class Object
  int main()
    if_minus( 10 - 12)
      return 3
    end
  end
end
HERE
  @expect =  [[SaveReturn,LoadConstant,LoadConstant,
                OperatorInstruction,IsMinus] ,
                [Branch] ,[LoadConstant]  ,[] ,
                [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end


  def test_if_small_zero
    @string_input = <<HERE
class Object
  int main()
    if_zero( 10 - 12)
      return 3
    end
  end
end
HERE
  @expect =  [[SaveReturn,LoadConstant,LoadConstant,
                OperatorInstruction,IsZero] ,
                [Branch] ,[LoadConstant]  ,[] ,
                [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end
end
end
