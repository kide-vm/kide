require_relative '../../helper'


module Statements

  def check
    machine = Register.machine
    machine.boot unless machine.booted
    machine.parse_and_compile @string_input
    produced = Register.machine.space.get_main.source
    assert @expect , "No output given"
    #assert_equal @expect.length ,  produced.instructions.length , "instructions length #{produced.instructions.to_ac}"
    compare_instructions produced.method.instructions , @expect
    produced.method.instructions
  end

  def compare_instructions instruction , expect
    index = 0
    begin
      should = expect[index]
      assert should , "No instruction at #{index}"
      assert_equal instruction.class , should , "Expected at #{index+1}"
      index += 1
      instruction = instruction.next
    end while( instruction )
  end


end
