require_relative '../helper'

module Register
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

    def preamble
      [Label, SlotToReg , LoadConstant, RegToSlot, LoadConstant,RegToSlot, LoadConstant, SlotToReg, SlotToReg ]
    end
    def postamble
      [ Label, FunctionReturn]
    end
    def check_nil
      assert @expect , "No output given"
      compiler = Typed::MethodCompiler.new
      code = Typed.ast_to_code( @input )
      assert code.to_s , @input
      produced = compiler.process( code )
      produced = Parfait.object_space.get_main.instructions
      compare_instructions produced , @expect
    end
    def check_return
      was = check_nil
      raise was if was
      Parfait.object_space.get_main.instructions
    end

    def compare_instructions( instruction , expect )
      index = 0
      all = instruction.to_arr
      full_expect = preamble + expect + postamble
      full_expect =  expect
      begin
        should = full_expect[index]
        return "No instruction at #{index}" unless should
        return "Expected at #{index+1}\n#{should(all)}" unless instruction.class == should
        index += 1
        instruction = instruction.next
      end while( instruction )
      nil
    end
    def should( all )
      #preamble.each {all.shift}
      #postamble.each {all.pop}
      str = all.to_s.gsub("Register::","")
      ret = ""
      str.split(",").each_slice(6).each do |line|
        ret += "                " + line.join(",") + " ,\n"
      end
      ret
    end
  end
end
