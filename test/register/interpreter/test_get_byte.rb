require_relative "helper"

class TestInterpretSetByte < MiniTest::Test
  include Ticker

  def setup
      @string_input = <<HERE
class Space
  int main()
    "Hello".set_internal_byte(1,104)
  end
end
HERE
    @input =  s(:statements, s(:call,
                  s(:name, :set_internal_byte),
                  s(:arguments, s(:int, 1), s(:int, 104)),
                    s(:receiver, s(:string, "Hello"))))
    super
  end

  def test_chain
    #show_ticks # get output of what is
    check_chain ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","FunctionCall","Label","GetSlot",
     "LoadConstant","SetSlot","LoadConstant","SetSlot","LoadConstant",
     "SetSlot","LoadConstant","SetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","RegisterTransfer","FunctionCall","Label",
     "GetSlot","GetSlot","GetSlot","SetByte","Label",
     "FunctionReturn","RegisterTransfer","GetSlot","GetSlot","Label",
     "FunctionReturn","RegisterTransfer","Syscall","NilClass"]
  end

  def test_branch
    was = @interpreter.instruction
    assert_equal Register::Branch , ticks(1).class
    assert was != @interpreter.instruction
    assert @interpreter.instruction , "should have gone to next instruction"
  end
  def test_load
    assert_equal Register::LoadConstant ,  ticks(3).class
    assert_equal Parfait::Space , @interpreter.get_register(:r2).class
    assert_equal :r2,  @interpreter.instruction.array.symbol
  end
  def test_get
    assert_equal Register::GetSlot , ticks(4).class
    assert @interpreter.get_register( :r1 )
    assert Integer , @interpreter.get_register( :r1 ).class
  end
  def test_call
    assert_equal Register::FunctionCall ,  ticks(8).class
  end
  def test_exit
    done = ticks(39)
    assert_equal NilClass ,  done.class
  end

  def test_set_byte
    done = ticks(29)
    assert_equal Register::SetByte ,  done.class
    assert_equal "h".ord ,  @interpreter.get_register(done.register)
  end

end
