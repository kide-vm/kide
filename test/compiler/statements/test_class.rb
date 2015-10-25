require_relative 'helper'

module Register
class TestBasicClass < MiniTest::Test
  include Statements

  def test_class_def
    @string_input = <<HERE
class Bar
  int self.buh()
    return 1
  end
end
class Object
  int main()
    return 1
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant,Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end
end
end
