require_relative 'helper'

module Register
  class TestWhile < MiniTest::Test
    include Statements


    def test_while_mini
      @string_input    = <<HERE
class Object
  int main()
    while(1)
      return 3
    end
  end
end
HERE
      @expect = [[SaveReturn],[LoadConstant,IsZeroBranch,LoadConstant,AlwaysBranch],
                  [],[RegisterTransfer,GetSlot,FunctionReturn]]
      check
    end

    def test_while_assign
      @string_input    = <<HERE
class Object
  int main()
    int n = 5
    while(n > 0)
      n = n - 1
    end
  end
end
HERE
      @expect = [[SaveReturn,LoadConstant,GetSlot,SetSlot],[GetSlot,GetSlot,LoadConstant,OperatorInstruction,
                  IsZeroBranch,GetSlot,GetSlot,LoadConstant,OperatorInstruction,GetSlot,SetSlot,AlwaysBranch],
                  [],[RegisterTransfer,GetSlot,FunctionReturn]]
      check
    end


    def test_while_return
      @string_input    = <<HERE
class Object
  int main()
    int n = 10
    while( n > 5)
      n = n + 1
      return n
    end
  end
end
HERE
      @expect = [[SaveReturn,LoadConstant,GetSlot,SetSlot],
                 [GetSlot,GetSlot,LoadConstant,OperatorInstruction,IsZeroBranch,GetSlot,
                   GetSlot,LoadConstant,OperatorInstruction,GetSlot,SetSlot,GetSlot,
                   GetSlot,AlwaysBranch] ,
                   [],[RegisterTransfer,GetSlot,FunctionReturn]]
      check
    end
  end
end
