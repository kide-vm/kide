require_relative '../../helper'


module Statements

  def check
    machine = Register.machine
    machine.boot unless machine.booted
    machine.parse_and_compile @string_input
    produced = Register.machine.space.get_main.instructions
    assert @expect , "No output given"
    #assert_equal @expect.length ,  produced.instructions.length , "instructions length #{produced.instructions.to_ac}"
    compare_instructions produced , @expect
    produced
  end

  def compare_instructions instruction , expect
    index = 0
    start = instruction
    begin
      should = expect[index]
      assert should , "No instruction at #{index}"
      assert_equal instruction.class , should , "Expected at #{index+1}\n#{should(start)}"
      index += 1
      instruction = instruction.next
    end while( instruction )
  end
  def should start
    str = start.to_ac.to_s
    str.gsub!("Register::","")
    ret = ""
    str.split(",").each_slice(7).each do |line|
      ret += "              " + line.join(",") + " ,\n"
    end
    ret
  end
end
