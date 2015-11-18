require_relative 'helper'

module Register
class TestClassStatements < MiniTest::Test
  include Statements

  def test_class_defs
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
    @expect =  [Label, LoadConstant,SetSlot,Label,FunctionReturn]
    check
  end

  def test_class_call
    @string_input = <<HERE
class Bar
  int self.buh()
    return 1
  end
end
class Object
  int main()
    return Bar.buh()
  end
end
HERE
    @expect = [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
    check
  end

  def test_class_field_value
    @string_input = <<HERE
class Object
  field int boo1 = 1
  int main()
    return 1
  end
end
HERE
    @expect =  [Label, LoadConstant,SetSlot,Label,FunctionReturn]
    assert_raises{check}
  end

  def test_class_field
    @string_input = <<HERE
class Object
  field int boo2
  int main()
    return self.boo2
  end
end
HERE
    @expect =  [Label, GetSlot,GetSlot,SetSlot,Label,FunctionReturn]
    check
  end
end
end
