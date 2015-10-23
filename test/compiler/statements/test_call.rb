require_relative 'helper'

module Register
class TestCallStatement < MiniTest::Test
  include Statements

  def test_call_constant_int
    @string_input = <<HERE
class Integer
  int putint()
    return 1
  end
end
class Object
  int main()
    42.putint()
  end
end
HERE
    @expect =  [Label, SaveReturn,GetSlot,LoadConstant,
                  SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,GetSlot ,
                  Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end


  def test_call_constant_string
    @string_input = <<HERE
class Word
  int putstring()
    return 1
  end
end
class Object
  int main()
    "Hello".putstring()
  end
end
HERE
    @expect =  [Label, SaveReturn,GetSlot,LoadConstant,
                  SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,GetSlot ,
                  Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end

  def test_call_local_int
    @string_input = <<HERE
class Integer
  int putint()
    return 1
  end
end
class Object
  int main()
    int testi = 20
    testi.putint()
  end
end
HERE
    @expect =  [ Label, SaveReturn,LoadConstant,GetSlot,SetSlot,GetSlot,
                  GetSlot,GetSlot,SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,
                  GetSlot ,Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_call_local_class
    @string_input = <<HERE
class List < Object
  int add()
    return 1
  end
end
class Object
  int main()
    List test_l
    test_l.add()
  end
end
HERE
    @expect =  [ Label, SaveReturn,GetSlot,GetSlot,GetSlot,SetSlot,
                  LoadConstant,SetSlot,RegisterTransfer,FunctionCall,
                  GetSlot ,Label,RegisterTransfer,GetSlot,FunctionReturn]
  check
  end

  def test_call_puts
    @string_input    = <<HERE
class Object
int puts(Word str)
  return str
end
int main()
  puts("Hello")
end
end
HERE
    @expect = [ Label, SaveReturn , GetSlot,GetSlot,SetSlot,LoadConstant,SetSlot,LoadConstant,
                SetSlot,RegisterTransfer,FunctionCall,GetSlot,
                Label,RegisterTransfer,GetSlot,FunctionReturn]
    was = check
    set = was.next(8)
    assert_equal SetSlot , set.class
    assert_equal 9, set.index , "Set to message must be offset, not #{set.index}"
  end
end
end
