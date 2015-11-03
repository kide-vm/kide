require_relative "helper"

class TestPuts < MiniTest::Test
  include AST::Sexp
  include Ticker
  def setup
    machine = Register.machine.boot
    code =   s(:class, :Object,
                        s(:derives, nil),
                          s(:statements,
                            s(:function, :int,
                              s(:name, :main),
                              s(:parameters),
                              s(:statements,
                                s(:call,
                                  s(:name,  :putstring),
                                  s(:arguments),
                                  s(:receiver,
                                    s(:string,  "Hello again")))))))

    Soml.compile( code )
    machine.collect
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start Register.machine.init
  end

  def test_branch
    was = @interpreter.instruction
    assert_equal Register::Branch , ticks(1).class
    assert was != @interpreter.instruction
    assert @interpreter.instruction , "should have gone to next instruction"
  end
  def test_load
    assert_equal Register::LoadConstant ,  ticks(3).class
    assert_equal Parfait::Space ,  Register.machine.objects[ @interpreter.get_register(:r2)].class
    assert_equal :r2,  @interpreter.instruction.array.symbol
  end
  def test_get
    assert_equal Register::GetSlot , ticks(4).class
    assert @interpreter.get_register( :r1 )
    assert @interpreter.get_register( :r1 ).is_a? Integer
  end
  def test_transfer
    transfer = ticks 8
    assert_equal Register::RegisterTransfer ,  transfer.class
    assert_equal @interpreter.get_register(transfer.to) , @interpreter.get_register(transfer.from)
  end
  def test_call
    assert_equal Register::FunctionCall ,  ticks(9).class
  end

  def test_chain
    #show_ticks # get output of what is
    ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","RegisterTransfer","FunctionCall","Label",
     "GetSlot","LoadConstant","SetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","LoadConstant","SetSlot","RegisterTransfer",
     "FunctionCall","Label","GetSlot","RegisterTransfer","Syscall",
     "RegisterTransfer","RegisterTransfer","SetSlot","Label","RegisterTransfer",
     "GetSlot","FunctionReturn","GetSlot","Label","RegisterTransfer",
     "GetSlot","FunctionReturn","RegisterTransfer","Syscall","NilClass"].each_with_index do |name , index|
      got = ticks(1)
      #puts "TICK #{index}"
      assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
    end
  end

  def test_putstring
    done = ticks(25)
    assert_equal Register::Syscall ,  done.class
    assert_equal "Hello again" , @interpreter.stdout
  end

  def test_return
    done = ticks(32)
    assert_equal Register::FunctionReturn ,  done.class
    assert Register::Label , @interpreter.instruction.class
    assert @interpreter.instruction.is_a?(Register::Instruction) , "not instruction #{@interpreter.instruction}"
  end

  def test_exit
    done = ticks(40)
    assert_equal NilClass ,  done.class
    assert_equal "Hello again" , @interpreter.stdout
  end
end
