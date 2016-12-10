require_relative 'helper'

module Register
class TestCallStatement < MiniTest::Test
  include Statements

  def test_call_constant_int
    clean_compile s(:statements, s(:class, :Integer, s(:derives, nil), s(:statements, s(:function, :Integer, s(:name, :putint), s(:parameters), s(:statements, s(:return, s(:int, 1)))))))
    @input = s(:call, s(:name, :putint), s(:arguments), s(:receiver, s(:int, 42)))
    @expect =  [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, Label, FunctionReturn]
    check
  end


  def test_call_constant_string
    clean_compile s(:statements, s(:class, :Word, s(:derives, nil), s(:statements, s(:function, :Integer, s(:name, :putstring), s(:parameters), s(:statements, s(:return, s(:int, 1)))))))

    @input =s(:call, s(:name, :putstring), s(:arguments), s(:receiver, s(:string, "Hello")))
    @expect =  [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, Label, FunctionReturn]
    check
  end

  def _test_call_local_int
    clean_compile s(:statements, s(:class, :Integer, s(:derives, nil), s(:statements, s(:function, :Integer, s(:name, :putint), s(:parameters), s(:statements, s(:return, s(:int, 1)))))))
    @input = s(:statements, s(:field_def, :Integer, s(:name, :testi), s(:int, 20)), s(:call, s(:name, :putint), s(:arguments), s(:receiver, s(:name, :testi))))

    @expect = [Label, LoadConstant, GetSlot, SetSlot, GetSlot, GetSlot, GetSlot ,
               SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot ,
               RegisterTransfer, FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, Label ,
               FunctionReturn]
  check
  end

  def test_call_local_class
    clean_compile s(:statements, s(:class, :List, s(:derives, :Object), s(:statements, s(:function, :Integer, s(:name, :add), s(:parameters), s(:statements, s(:return, s(:int, 1)))))))

    @input =s(:statements, s(:field_def, :List, s(:name, :test_l)), s(:call, s(:name, :add), s(:arguments), s(:receiver, s(:name, :test_l))))
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
