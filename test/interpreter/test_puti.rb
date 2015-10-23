require_relative "helper"

class AddTest < MiniTest::Test
  include Ticker
  include AST::Sexp

  def test_puti
    @string_input = <<HERE
class Integer < Object
  Word digit( int rest )
    if_zero( rest == 5 )
      return "5"
    end
    if_zero( rest == 1 )
      return "1"
    end
    if_zero( rest == 2 )
      return "2"
    end
    if_zero( rest == 3 )
      return "3"
    end
    if_zero( rest == 4 )
      return "4"
    end
  end
  Word add_string(Word str)
    int div
    div = self / 10
    int rest
    rest = self - div
    if_notzero( rest )
      rest = self.digit( rest )
      str = str + rest
    else
      str = div.add_string(str)
    end
    return str
  end
  Word to_string()
    Word start = " "
    return add_string( start )
  end
end
class Object
  int main()
    5.to_string()
  end
end
HERE
    machine = Register.machine.boot
    syntax  = Parser::Salama.new.parse_with_debug(@string_input)
    parts = Parser::Transform.new.apply(syntax)
    #puts parts.inspect
    Soml::Compiler.compile( parts )
    machine.collect
#    statements = Register.machine.boot.parse_and_compile @string_input
#    Soml::Compiler.compile( statements , Register.machine.space.get_main )
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start Register.machine.init
    #show_ticks # get output of what is
    ["Branch","LoadConstant","GetSlot","SetSlot","RegisterTransfer",
     "FunctionCall","SaveReturn","GetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","RegisterTransfer","FunctionCall","SaveReturn",
     "LoadConstant","GetSlot","SetSlot","GetSlot","GetSlot",
     "SetSlot","LoadConstant","SetSlot","GetSlot","GetSlot",
     "SetSlot","RegisterTransfer","FunctionCall","SaveReturn","GetSlot",
     "LoadConstant","OperatorInstruction","GetSlot","SetSlot","GetSlot",
     "GetSlot","GetSlot","OperatorInstruction","GetSlot","SetSlot",
     "GetSlot","GetSlot","IsNotzero","GetSlot","GetSlot",
     "SetSlot","LoadConstant","SetSlot","GetSlot","GetSlot",
     "SetSlot","RegisterTransfer","FunctionCall","SaveReturn","GetSlot",
     "LoadConstant","OperatorInstruction","IsZero","Branch","GetSlot",
     "LoadConstant","OperatorInstruction","IsZero","LoadConstant","GetSlot",
     "LoadConstant","OperatorInstruction","IsZero","LoadConstant","GetSlot",
     "LoadConstant","OperatorInstruction","IsZero","LoadConstant","GetSlot",
     "LoadConstant","OperatorInstruction","IsZero","LoadConstant","RegisterTransfer",
     "GetSlot","FunctionReturn","GetSlot","GetSlot","SetSlot",
     "GetSlot","GetSlot","GetSlot","OperatorInstruction","SetSlot",
     "GetSlot","RegisterTransfer","GetSlot","FunctionReturn","GetSlot",
     "RegisterTransfer","GetSlot","FunctionReturn","GetSlot","RegisterTransfer",
     "GetSlot","FunctionReturn","RegisterTransfer","Syscall","NilClass"].each_with_index do |name , index|
    got = ticks(1)
    assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
end

  end
end
