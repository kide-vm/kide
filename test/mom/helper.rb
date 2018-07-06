require_relative '../helper'

module Risc
  module Statements

    def setup
      Parfait.boot!
      Risc::Builtin.boot_functions
    end

    def preamble
      [ Label ]
    end
    def postamble
      [ Label ]
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
    def as_test_main
      "class Test; def main(arg);#{@input};end;end"
    end
    def produce_instructions
      assert @expect , "No output given"
      linker = RubyX::RubyXCompiler.new(as_test_main).ruby_to_risc(:interpreter)
      compiler = linker.assemblers.find{|c| c.method.name == :main and c.method.self_type.object_class.name == :Test}
      compiler.instructions
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
    def compare_instructions( instruction , expect )
      index = 0
      all = instruction.to_arr
      full_expect = preamble + expect + postamble
      #full_expect =  expect
      begin
        should = full_expect[index]
        return "No instruction at #{index-1}\n#{should(all)[0..100]}" unless should
        return "Expected at #{index-1}\n#{should(all)} was #{instruction.to_s[0..100]}" unless instruction.class == should
        #puts "#{index-1}:#{instruction.to_s}" if (index > preamble.length) and (index + postamble.length <= full_expect.length)
        index += 1
        instruction = instruction.next
      end while( instruction )
      nil
    end
    def should( all )
      preamble.each {all.shift}
      postamble.each {all.pop}
      str = all.collect{|i| i.class.name}.join(", ").gsub("Risc::","")
      str = "[#{str}]"
      all = str.split(",").each_slice(5).collect { |line| "                " + line.join(",")}
      all.join(",\n")
    end
  end
end
