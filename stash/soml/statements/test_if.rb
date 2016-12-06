require_relative 'helper'

module Register
class TestIfStatement < MiniTest::Test
  include Statements

  def test_if_basicr
    @string_input = <<HERE
class Space
  int main()
    if_plus( 10 - 12)
      return 3
    else
      return 4
    end
  end
end
HERE
  @expect =  [Label, LoadConstant,LoadConstant, OperatorInstruction,IsPlus ,
                LoadConstant,SetSlot,Branch , Label , LoadConstant ,SetSlot,
                Label,Label,FunctionReturn]
  check
  end


  def test_if_small_minus
    @string_input = <<HERE
class Space
  int main()
    if_minus( 10 - 12)
      return 3
    end
  end
end
HERE
  @expect =  [Label, LoadConstant, LoadConstant, OperatorInstruction, IsMinus, Branch, Label ,
               LoadConstant, SetSlot, Label, Label, FunctionReturn]
  check
  end


  def test_if_small_zero
    @string_input = <<HERE
class Space
  int main()
    if_zero( 10 - 12)
      return 3
    end
  end
end
HERE
  @expect =  [Label, LoadConstant,LoadConstant,OperatorInstruction,IsZero ,
                Branch , Label , LoadConstant ,SetSlot,
                Label,Label, FunctionReturn]
  check
  end
end
end
