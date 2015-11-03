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
    Soml.compile( parts )
    machine.collect
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start Register.machine.init
    #show_ticks # get output of what is
    ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","RegisterTransfer","FunctionCall","Label",
     "GetSlot","LoadConstant","SetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","LoadConstant","SetSlot","RegisterTransfer",
     "FunctionCall","Label","LoadConstant","GetSlot","SetSlot",
     "GetSlot","GetSlot","SetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","GetSlot","GetSlot","SetSlot",
     "LoadConstant","SetSlot","RegisterTransfer","FunctionCall","Label",
     "GetSlot","LoadConstant","OperatorInstruction","GetSlot","SetSlot",
     "GetSlot","GetSlot","GetSlot","OperatorInstruction","GetSlot",
     "SetSlot","GetSlot","GetSlot","IsNotzero","Label",
     "GetSlot","GetSlot","SetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","GetSlot","GetSlot","SetSlot",
     "LoadConstant","SetSlot","RegisterTransfer","FunctionCall","Label",
     "GetSlot","LoadConstant","OperatorInstruction","IsZero","Branch",
     "Label","GetSlot","LoadConstant","OperatorInstruction","IsZero",
     "Label","LoadConstant","SetSlot","Label","GetSlot",
     "LoadConstant","OperatorInstruction","IsZero","Label","LoadConstant",
     "SetSlot","Label","GetSlot","LoadConstant","OperatorInstruction",
     "IsZero","Label","LoadConstant","SetSlot","Label",
     "GetSlot","LoadConstant","OperatorInstruction","IsZero","Label",
     "LoadConstant","SetSlot","Label","Label","RegisterTransfer",
     "GetSlot","FunctionReturn","GetSlot","GetSlot","SetSlot",
     "GetSlot","GetSlot","GetSlot","OperatorInstruction","SetSlot",
     "Label","GetSlot","SetSlot","Label","RegisterTransfer",
     "GetSlot","FunctionReturn","GetSlot","SetSlot","Label",
     "RegisterTransfer","GetSlot","FunctionReturn","GetSlot","Label",
     "RegisterTransfer","GetSlot","FunctionReturn","RegisterTransfer","Syscall",
     "NilClass"].each_with_index do |name , index|
    got = ticks(1)
    assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
end

  end
end
