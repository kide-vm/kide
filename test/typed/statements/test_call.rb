require_relative 'helper'

module Register
class TestCallStatement < MiniTest::Test
  include Statements

  def test_call_constant_int
    clean_compile :Integer, :puti, {}, s(:statements, s(:return, s(:int, 1)))
    @input = s(:call, s(:name, :puti), s(:arguments), s(:receiver, s(:int, 42)))
    @expect =  [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, Label, FunctionReturn]
    check
  end


  def test_call_constant_string
    clean_compile :Word, :putstr,{}, s(:statements, s(:return, s(:int, 1)))

    @input =s(:call, s(:name, :putstr), s(:arguments), s(:receiver, s(:string, "Hello")))
    @expect =  [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, Label, FunctionReturn]
    check
  end

  def _test_call_local_int
    Register.machine.space.get_main.add_local(:testi , :Integer)
    clean_compile :Integer, :putint, {}, s(:statements, s(:return, s(:int, 1)))
    @input = s(:statements, s(:assignment, s(:name, :testi), s(:int, 20)), s(:call, s(:name, :putint), s(:arguments), s(:receiver, s(:name, :testi))))

    @expect = [Label, LoadConstant, GetSlot, SetSlot, GetSlot, GetSlot, GetSlot ,
               SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot ,
               RegisterTransfer, FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, Label ,
               FunctionReturn]
  check
  end

  def test_call_local_class
    Register.machine.space.get_main.add_local(:test_l , :List)
    clean_compile :List, :add, {}, s(:statements, s(:return, s(:int, 1)))

    @input =s(:statements, s(:call, s(:name, :add), s(:arguments), s(:receiver, s(:name, :test_l))))
    @expect = [Label, GetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot ,
               LoadConstant, SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label ,
               RegisterTransfer, GetSlot, GetSlot, Label, FunctionReturn]
  check
  end

  def _test_call_puts
    @input    = <<HERE
class Space
int puts(Word str)
  return str
end
int main()
  puts("Hello")
end
end
HERE
    @expect = [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall ,
               Label, RegisterTransfer, GetSlot, GetSlot, Label, FunctionReturn]
    was = check
    set = was.next(7)
    assert_equal SetSlot , set.class
    assert_equal 9, set.index , "Set to message must be offset, not #{set.index}"
  end
end
end
