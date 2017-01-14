require_relative 'helper'

module Vm
class TestWord < MiniTest::Test
  include Fragments

  def test_word_new
    @string_input = <<HERE
class Space
  Word self.new()
    return nil
  end
end
class Space
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
end
