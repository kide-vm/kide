require_relative "helper"

class AddTest < MiniTest::Test
  include AST::Sexp
  include Ticker

  def setup
    Virtual.machine.boot
    code  =   s(:class, :Object,
                s(:derives, nil),
                  s(:statements,
                    s(:function, :int,
                      s(:name, :main),
                      s(:parameters),
                      s(:statements,
                        s(:call,
                          s(:name,  :plus),
                          s(:arguments , s(:int , 5)),
                          s(:receiver, s(:int,  2)))))))
    Phisol::Compiler.compile( code  )
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
  def test_adding
    done = ticks(23)
    assert_equal Register::OperatorInstruction ,  done.class
    left = @interpreter.get_register(done.left)
    rr = done.right
    right = @interpreter.get_register(rr)
    assert_equal Fixnum , left.class
    assert_equal Fixnum , right.class
    assert_equal 16 , right
    assert_equal 8 , left
    done = ticks(1)
    assert_equal Register::RegisterTransfer ,  done.class
    result = @interpreter.get_register(rr)
    assert_equal result , 16
  end

  def test_chain
    ["Branch" , "LoadConstant" , "GetSlot" , "SetSlot" , "RegisterTransfer" ,
     "GetSlot" , "FunctionCall" , "SaveReturn" , "LoadConstant"  , "SetSlot" ,
     "GetSlot" ,  "GetSlot" , "SetSlot" , "LoadConstant" , "SetSlot" ,
     "LoadConstant" ,  "SetSlot" ,  "RegisterTransfer" , "GetSlot" , "FunctionCall" ,
     "SaveReturn" ,  "GetSlot", "OperatorInstruction" , "RegisterTransfer" , "GetSlot" , "GetSlot" ,
     "GetSlot" , "FunctionReturn" ,"RegisterTransfer" , "Syscall", "NilClass"].each_with_index do |name , index|
      got = ticks(1)
      puts got
      assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
    end
  end


#  def test_exit
#    done = ticks(34)
#    assert_equal NilClass ,  done.class
#  end
end
