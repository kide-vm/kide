require_relative '../../helper'
require "interpreter/interpreter"

# Fragments are small programs that we run through the interpreter and really only check
# - the no. of instructions processed
# - the stdout output



module Fragments

  def setup
    @stdout =  ""
  end
  def check
    machine = Register.machine.boot
    machine.parse_and_compile @string_input
    machine.collect
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start machine.init
    count = 0
    begin
      count += 1
      #puts interpreter.instruction
      @interpreter.tick
    end while( ! @interpreter.instruction.nil?)
    assert_equal @length , count
    assert_equal @stdout , @interpreter.stdout
  end

end
