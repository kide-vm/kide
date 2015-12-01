require_relative '../helper'
require "register/interpreter"
require "parser/ruby22"

module MelonTests

  def setup
    @parser = Parser::Ruby22
  end

  def check
    assert true
    puts @parser.parse @string_input
  end
end
