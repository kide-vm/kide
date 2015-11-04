require_relative 'helper'

module Register
  class TestWhile < MiniTest::Test
    include Statements


    def test_while_mini
      @string_input    = <<HERE
class Object
  int main()
    while_plus(1)
      return 3
    end
  end
end
HERE
      @expect = [Label, Branch, Label, LoadConstant, SetSlot, Label, LoadConstant ,
               IsPlus, Label, RegisterTransfer, GetSlot, FunctionReturn]
      check
    end

    def test_while_assign
      @string_input    = <<HERE
class Object
  int main()
    int n = 5
    while_plus(n)
      n = n - 1
    end
    return n
  end
end
HERE
      @expect = [Label, LoadConstant, GetSlot, SetSlot, Branch, Label, GetSlot ,
               GetSlot, LoadConstant, OperatorInstruction, GetSlot, SetSlot, Label, GetSlot ,
               GetSlot, IsPlus, GetSlot, GetSlot, SetSlot, Label, RegisterTransfer ,
               GetSlot, FunctionReturn]
      check
    end


    def test_while_return
      @string_input    = <<HERE
class Object
  int main()
    int n = 10
    while_plus( n - 5)
      n = n + 1
      return n
    end
  end
end
HERE
      @expect = [Label, LoadConstant, GetSlot, SetSlot, Branch, Label, GetSlot ,
               GetSlot, LoadConstant, OperatorInstruction, GetSlot, SetSlot, GetSlot, GetSlot ,
               SetSlot, Label, GetSlot, GetSlot, LoadConstant, OperatorInstruction, IsPlus ,
               Label, RegisterTransfer, GetSlot, FunctionReturn]
      check
    end
  end
end
