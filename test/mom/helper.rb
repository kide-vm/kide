require_relative '../helper'

module Risc

  module Statements
    include AST::Sexp
    include CleanCompile

    def setup
      Risc.machine.boot # force boot to reset main
    end

    def preamble
      [Label ]
    end
    def postamble
      [ Label]
    end
    # test hack to in place change object type
    def add_space_field(name,type)
      class_type = Parfait.object_space.get_class_by_name(:Space).instance_type
      class_type.send(:private_add_instance_variable, name , type)
    end
    def produce_body
      produced = produce_instructions
      preamble.each{ produced = produced.next }
      produced
    end
    def produce_instructions
      assert @expect , "No output given"
      Vool::VoolCompiler.ruby_to_vool "class Test; def main(arg);#{@input};end;end"
      test = Parfait.object_space.get_class_by_name :Test
      test.instance_type.get_method( :main).risc_instructions
    end
    def check_nil
      produced = produce_instructions
      compare_instructions produced , @expect
    end
    def check_return
      was = check_nil
      raise was if was
      test = Parfait.object_space.get_class_by_name :Test
      test.instance_type.get_method :main
    end
    def real_index(index)
      index - preamble.length
    end
    def compare_instructions( instruction , expect )
      index = 0
      all = instruction.to_arr
      full_expect = preamble + expect + postamble
      #full_expect =  expect
      begin
        should = full_expect[index]
        return "No instruction at #{real_index(index)}\n#{should(all)}" unless should
        return "Expected at #{real_index(index)}\n#{should(all)} was #{instruction.to_s}" unless instruction.class == should
        #puts instruction.to_s if (index > preamble.length) and (index + postamble.length <= full_expect.length)
        index += 1
        instruction = instruction.next
      end while( instruction )
      nil
    end
    def should( all )
      preamble.each {all.shift}
      postamble.each {all.pop}
      str = all.to_s.gsub("Risc::","")
      ret = ""
      str.split(",").each_slice(5).each do |line|
        ret += "                " + line.join(",") + " ,\n"
      end
      ret
    end
  end
end
