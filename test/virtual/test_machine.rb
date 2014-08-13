require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_object
    @string_input    = <<HERE
class Object
  def get_class()
    @layout.get_class()
  end
end
HERE
    @output = ""
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