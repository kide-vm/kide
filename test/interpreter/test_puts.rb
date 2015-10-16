require_relative "helper"

class TestPuts < MiniTest::Test
  include AST::Sexp
  include Ticker
  def setup
    Virtual.machine.boot
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

    Phisol::Compiler.compile( code )
    Virtual.machine.run_before "Register::CallImplementation"
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start Virtual.machine.init
  end

  def test_branch
    was = @interpreter.block
    assert_equal Register::Branch , ticks(1).class
    assert was != @interpreter.block
  end
  def test_load
    assert_equal Register::LoadConstant ,  ticks(2).class
    assert_equal Parfait::Space ,  Virtual.machine.objects[ @interpreter.get_register(:r1)].class
    assert_equal :r1,  @interpreter.instruction.array.symbol
  end
  def test_get
    assert_equal Register::GetSlot , ticks(3).class
    assert @interpreter.get_register( :r3 )
    assert @interpreter.get_register( :r3 ).is_a? Integer
  end
  def test_transfer
    transfer = ticks 5
    assert_equal Register::RegisterTransfer ,  transfer.class
    assert_equal @interpreter.get_register(transfer.to) , @interpreter.get_register(transfer.from)
  end
  def test_call
    assert_equal Register::FunctionCall ,  ticks(7).class
    assert @interpreter.link
  end
  def test_save
    done = ticks(8)
    assert_equal Register::SaveReturn ,  done.class
    assert @interpreter.get_register done.register.symbol
  end

  def test_chain
    ["Branch" , "LoadConstant" , "GetSlot" , "SetSlot" , "RegisterTransfer" ,
     "GetSlot" , "FunctionCall" , "SaveReturn" , "LoadConstant"  , "GetSlot" ,
     "SetSlot" ,  "LoadConstant" , "SetSlot" , "RegisterTransfer" , "GetSlot" ,
     "FunctionCall" ,  "SaveReturn" ,  "RegisterTransfer" , "Syscall" , "RegisterTransfer" ,
     "RegisterTransfer" , "SetSlot" , "GetSlot" , "GetSlot" , "RegisterTransfer" ,
     "GetSlot" , "GetSlot" ,"GetSlot" , "FunctionReturn","RegisterTransfer",
     "Syscall" , "NilClass"].each_with_index do |name , index|
      got = ticks(1)
      #puts "TICK #{index}"
      assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
    end
  end

  def test_putstring
    done = ticks(19)
    assert_equal Register::Syscall ,  done.class
    assert_equal "Hello again" , @interpreter.stdout
  end

  def test_return
    done = ticks(29)
    assert_equal Register::FunctionReturn ,  done.class
    assert @interpreter.block.is_a?(Virtual::Block)
    assert @interpreter.instruction.is_a?(Register::Instruction) , "not instruction #{@interpreter.instruction}"
  end

  def test_exit
    done = ticks(32)
    assert_equal NilClass ,  done.class
    assert_equal "Hello again" , @interpreter.stdout
  end
end
