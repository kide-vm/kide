require_relative 'helper'


module Register
  class TestFieldStatement < MiniTest::Test
    include Statements

    def test_field_frame
      @string_input = <<HERE
class Object
  int main()
    Message m
    return m.name
  end
end
HERE
      @expect =  [Label, GetSlot, GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
      check
    end

    def test_field_arg
      @string_input = <<HERE
class Object
  int get_name(Message main)
    return main.name
  end
  int main()
    Message m
    return get_name(m)
  end
end
HERE
      @expect =  [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
                 SetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, RegisterTransfer ,
                 FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, SetSlot, Label ,
                 FunctionReturn]
      check
    end

    def test_self_field
      @string_input = <<HERE
class Object
  int main()
    Layout l = self.layout
    return 1
  end
end
HERE
      @expect =  [Label, GetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot ,
                  Label, FunctionReturn]
      check
    end

    def test_message_field
      @string_input = <<HERE
class Object
  int main()
    Word name = message.name
    return name
  end
end
HERE
      @expect =   [Label, RegisterTransfer, GetSlot, GetSlot, SetSlot, GetSlot, GetSlot ,
               SetSlot, Label, FunctionReturn]
      check
    end
  end
end
