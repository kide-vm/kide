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
    @expect =  [[SaveReturn,GetSlot,LoadConstant,
                  SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,GetSlot] ,
                  [RegisterTransfer,GetSlot,FunctionReturn]]
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
    @expect =  [[SaveReturn,GetSlot,LoadConstant,
                  SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,GetSlot] ,
                  [RegisterTransfer,GetSlot,FunctionReturn]]
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
    @expect =  [ [SaveReturn,LoadConstant,GetSlot,SetSlot,GetSlot,
                  GetSlot,GetSlot,SetSlot,LoadConstant,SetSlot,RegisterTransfer,FunctionCall,
                  GetSlot] ,[RegisterTransfer,GetSlot,FunctionReturn] ]
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
    @expect =  [ [SaveReturn,GetSlot,GetSlot,GetSlot,SetSlot,
                  LoadConstant,SetSlot,RegisterTransfer,FunctionCall,
                  GetSlot] ,[RegisterTransfer,GetSlot,FunctionReturn] ]
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
    @expect = [ [SaveReturn , GetSlot,GetSlot,SetSlot,LoadConstant,SetSlot,LoadConstant,
                 SetSlot,RegisterTransfer,FunctionCall,GetSlot],
                [RegisterTransfer,GetSlot,FunctionReturn]]
    check
  end

end
end