require_relative '../helper'


module Statements
  include AST::Sexp

  def check
    assert @expect , "No output given"
    Register.machine.boot # force boot to reset main 
    compiler = Typed::Compiler.new Register.machine.space.get_main
    produced = compiler.process( Typed.ast_to_code( @input) )
    assert_nil produced.first , "Statements should result in nil"
    produced = Register.machine.space.get_main.instructions
    compare_instructions produced , @expect
    produced
  end

  def as_main(statements)
    s(:statements, s(:class, :Space, s(:derives, nil), statements ))
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
      ret += "                " + line.join(",") + " ,\n"
    end
    ret
  end
end
