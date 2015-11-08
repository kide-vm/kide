require_relative 'helper'


module Register
  class TestFieldStatement < MiniTest::Test
    include Statements

    def test_field_frame
      @string_input = <<HERE
class Fielded
  field int one
end
class Object
  int main()
    Fielded f
    return f.one
  end
end
HERE
      @expect =  [Label, GetSlot, SetSlot, Label, FunctionReturn]
      check
    end

    def test_field_arg
      @string_input = <<HERE
class Fielded
  field int one
end
class Object
  int the_one(Fielded f)
    return f.one
  end
  int main()
    Fielded f
    return the_one(f)
  end
end
HERE
      @expect =  [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
                 SetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, RegisterTransfer ,
                 FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, SetSlot, Label ,
                 FunctionReturn]
      check
    end
  end
end
