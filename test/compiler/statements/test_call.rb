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
    @expect =  [[Virtual::MethodEnter,LoadConstant,GetSlot,
                  SetSlot,LoadConstant,SetSlot,Virtual::MethodCall,GetSlot] ,
                  [Virtual::MethodReturn]]
    check
  end


  def test_call_constant_string
    @string_input = <<HERE
class Object
  int main()
    "Hello".putstring()
  end
end
HERE
    @expect =  [[Virtual::MethodEnter,LoadConstant,GetSlot,
                  SetSlot,LoadConstant,SetSlot,Virtual::MethodCall,GetSlot] ,
                  [Virtual::MethodReturn]]
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
    @expect =  [ [Virtual::MethodEnter,LoadConstant,SetSlot,GetSlot,
                  GetSlot,SetSlot,LoadConstant,SetSlot,Virtual::MethodCall,
                  GetSlot] ,[Virtual::MethodReturn] ]
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
    @expect =  [ [Virtual::MethodEnter,GetSlot,GetSlot,SetSlot,
                  LoadConstant,SetSlot,Virtual::MethodCall,
                  GetSlot] ,[Virtual::MethodReturn] ]
  check
  end

  def test_puts_string
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
    @expect = [ [Virtual::MethodEnter , GetSlot,SetSlot,LoadConstant,SetSlot,LoadConstant,
                 SetSlot,Virtual::MethodCall,GetSlot],
                [Virtual::MethodReturn]]
    check
  end

end
end
