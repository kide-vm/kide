require_relative "helper"

class AddTest < MiniTest::Test
  include Ticker

  def test_puti
    @string_input = <<HERE
class Integer < Object
  ref add_string(ref str)
    int div
    div = self / 10
    int rest
    rest = self - div
    if( rest < 0)
      str = str + digit( rest )
    else
      str = div.add_string(str)
    end
    return str
  end
  ref to_string()
    ref start = " "
    return add_string( start )
  end
end

HERE
    expressions = Virtual.machine.boot.compile_main @string_input
    puts expressions
#    Bosl::Compiler.compile( expressions , Virtual.machine.space.get_main )
    Virtual.machine.run_before "Register::CallImplementation"
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start Virtual.machine.init
#    done = ticks(34)
  ["Branch" , "LoadConstant" , "GetSlot" , "SetSlot" , "RegisterTransfer" ,
   "GetSlot" , "FunctionCall" , "SaveReturn" , "RegisterTransfer"  , "GetSlot" ,
   "GetSlot" ,  "GetSlot" , "SetSlot" , "LoadConstant" , "SetSlot" ,
   "LoadConstant" ,  "SetSlot" ,  "RegisterTransfer" , "GetSlot" , "FunctionCall" ,
   "SaveReturn" ,  "GetSlot", "OperatorInstruction" , "RegisterTransfer" , "GetSlot" , "GetSlot" ,
   "GetSlot" , "FunctionReturn" ,"RegisterTransfer" , "Syscall", "NilClass"].each_with_index do |name , index|
     return if index == 10
    got = ticks(1)
    puts got
    assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
end

  end
end
