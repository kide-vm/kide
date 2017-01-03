require_relative '../helper'

module ExpressionHelper

  def check
    Register.machine.boot unless Register.machine.booted
    compiler = Typed::MethodCompiler.new Parfait.object_space.get_main
    code = Typed.ast_to_code @input
    assert code.to_s , @input
    produced = compiler.process( code )
    assert @output , "No output given"
    assert_equal produced.class , @output , "Wrong class"
    produced
  end

  # test hack to in place change object type
  def add_space_field(name,type)
    class_type = Parfait.object_space.get_class_by_name(:Space).instance_type
    class_type.send(:private_add_instance_variable, name , type)
  end
end

module Statements
  include AST::Sexp
  include Compiling

  def setup
    Register.machine.boot # force boot to reset main
  end


  def check
    assert @expect , "No output given"
    compiler = Typed::MethodCompiler.new
    code = Typed.ast_to_code( @input )
    assert code.to_s , @input
    produced = compiler.process( code )
    produced = Parfait.object_space.get_main.instructions
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
      ret += "                " + line.join(",") + " ,\n"
    end
    ret
  end
end
