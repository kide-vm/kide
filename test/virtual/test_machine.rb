#require_relative "compiler_helper"

class TestMachine #< MiniTest::Test
  #include CompilerHelper

  def test_object
    @string_input    = <<HERE
class Object
  def get_class()
    @layout.get_class()
  end
end
HERE
    @output = nil
    check
  end

  def test_message_tpye
    @string_input    = <<HERE
class Message
  def get_type_for(name)
    index = @layout.get_index(name)
    get_at(index)
  end
end
HERE
    @output = ""
    check
  end

end
