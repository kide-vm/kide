require_relative '../helper'

module Risc
  module SpaceHack
    # test hack to in place change object type
    def add_space_field(name,type)
      class_type = Parfait.object_space.get_class_by_name(:Space).instance_type
      class_type.send(:private_add_instance_variable, name , type)
    end
  end
  module ExpressionHelper
    include SpaceHack

    def check
      Risc.machine.boot unless Risc.machine.booted
      compiler = Vm::MethodCompiler.new Parfait.object_space.get_main
      code = Vm.ast_to_code @input
      assert code.to_s , @input
      produced = compiler.process( code )
      assert @output , "No output given"
      assert_equal produced.class , @output , "Wrong class"
      produced
    end

  end

  module Statements
    include AST::Sexp
    include CleanCompile
    include SpaceHack

    def setup
      Risc.machine.boot # force boot to reset main
    end

    def preamble
      [Label, SlotToReg , LoadConstant, RegToSlot, LoadConstant,RegToSlot, LoadConstant, SlotToReg, SlotToReg ]
    end
    def postamble
      [ Label, FunctionReturn]
    end
    def check_nil
      assert @expect , "No output given"

      Vool::VoolCompiler.ruby_to_vool "class Space; def main(arg);#{@input};end;end"

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
      str = all.to_s.gsub("Risc::","")
      ret = ""
      str.split(",").each_slice(6).each do |line|
        ret += "                " + line.join(",") + " ,\n"
      end
      ret
    end
  end
end
