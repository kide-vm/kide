require_relative "helper"

class AddTest < MiniTest::Test
  include Ticker
  include AST::Sexp

  def test_puti
    @string_input = <<HERE
class Integer < Object
  ref digit( int rest )
    if( rest == 5 )
      return "5"
    end
    if( rest == 1 )
      return "1"
    end
    if( rest == 2 )
      return "2"
    end
    if( rest == 3 )
      return "3"
    end
    if( rest == 4 )
      return "4"
    end
  end
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
class Object
  int main()
    5.to_string()
  end
end
HERE
    Virtual.machine.boot
    syntax  = Parser::Salama.new.parse_with_debug(@string_input)
    parts = Parser::Transform.new.apply(syntax)
    puts parts.inspect
    Bosl::Compiler.compile( parts )

#    expressions = Virtual.machine.boot.parse_and_compile @string_input
#    Bosl::Compiler.compile( expressions , Virtual.machine.space.get_main )
    Virtual.machine.run_before "Register::CallImplementation"
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start Virtual.machine.init
#    done = ticks(34)
  ["Branch" ,     "LoadConstant" ,    "GetSlot" ,     "SetSlot" ,      "RegisterTransfer" ,
   "GetSlot" ,    "FunctionCall" ,    "SaveReturn",   "LoadConstant" , "SetSlot" ,
   "GetSlot" ,    "GetSlot" ,         "SetSlot" ,     "LoadConstant" , "SetSlot" ,
   "RegisterTransfer" ,"GetSlot" ,    "FunctionCall" ,"SaveReturn" ,   "GetSlot" ,
   "LoadConstant", "SetSlot",         "GetSlot" ,     "GetSlot" ,      "SetSlot" ,
   "LoadConstant", "SetSlot" ,        "GetSlot" ,     "SetSlot" ,      "RegisterTransfer",
   "GetSlot",     "FunctionCall",     "SaveReturn",   "GetSlot",       "LoadConstant",
   "SetSlot",     "GetSlot",          "GetSlot",      "OperatorInstruction", "GetSlot",
   "SetSlot",     "GetSlot",          "GetSlot",      "OperatorInstruction", "GetSlot",
   "SetSlot",     "LoadConstant",     "SetSlot",      "GetSlot",        "GetSlot",
   "OperatorInstruction",     "Branch",     "GetSlot",      "GetSlot",        "SetSlot",
   "LoadConstant",     "SetSlot",     "GetSlot",      "SetSlot",        "RegisterTransfer",
   "GetSlot",     "FunctionCall",     "SaveReturn",      "LoadConstant",        "SetSlot",
   "GetSlot",     "GetSlot",     "OperatorInstruction",      "Branch",        "LoadConstant",
   "SetSlot"].each_with_index do |name , index|
    got = ticks(1)
    puts got
    assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
end

  end
end
