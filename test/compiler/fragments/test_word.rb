require_relative 'helper'

class TestWord < MiniTest::Test
  include Fragments

  def test_hello
    @string_input = <<HERE
class Object
  Word self.new()
    return nil
  end
end
class Object
  int main()
    Word w = Word.new()
  end
end
HERE
    @length = 34
    @stdout = ""
    check
  end
end
