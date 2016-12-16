require_relative "helper"

class AddTest < MiniTest::Test
  include Ticker

  def setup
    @string_input = <<HERE
class Space
  int main()
    return 5 + 7
  end
end
HERE
    @input =  s(:statements, s(:return, s(:operator_value, :+, s(:int, 5), s(:int, 7))))
    super
  end

  def test_chain
    #show_ticks # get output of what is
    check_chain ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","FunctionCall","Label","LoadConstant",
     "LoadConstant","OperatorInstruction","SetSlot","Label","FunctionReturn",
     "RegisterTransfer","Syscall","NilClass"]
  end

  def test_get
    assert_equal Register::GetSlot , ticks(4).class
    assert @interpreter.get_register( :r2 )
    assert  Integer , @interpreter.get_register( :r2 ).class
  end
  def test_transfer
    transfer = ticks 16
    assert_equal Register::RegisterTransfer ,  transfer.class
    assert_equal @interpreter.get_register(transfer.to) , @interpreter.get_register(transfer.from)
  end
  def test_call
    ret = ticks(15)
    assert_equal Register::FunctionReturn ,  ret.class

    object = @interpreter.get_register( ret.register )
    link = object.get_internal_word( ret.index )

    assert_equal Register::Label , link.class
  end
  def test_adding
    done_op = ticks(12)
    assert_equal Register::OperatorInstruction ,  done_op.class
    left = @interpreter.get_register(done_op.left)
    rr = done_op.right
    right = @interpreter.get_register(rr)
    assert_equal Fixnum , left.class
    assert_equal Fixnum , right.class
    assert_equal 7 , right
    assert_equal 12 , left
    done_tr = ticks(4)
    assert_equal Register::RegisterTransfer ,  done_tr.class
    result = @interpreter.get_register(done_op.left)
    assert_equal result , 12
  end
end
