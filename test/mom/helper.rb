require_relative '../helper'

module Risc
  module Statements
    include Output
    def setup
    end

    def preamble
      [ Label ]
    end
    def postamble
      [Label, SlotToReg, SlotToReg, RegToSlot,SlotToReg,
       SlotToReg, SlotToReg, FunctionReturn,  Label,]
    end
    def produce_body
      produced = produce_main
      preamble.each{ produced = produced.next }
      produced
    end

    def as_block( block_input , method_input = "main_local = 5")
      "#{method_input} ; self.main{|val| #{block_input}}"
    end
    def as_main
      "class Space; #{@class_input if @class_input};def main(arg);#{@input};end;end"
    end
    def to_target
      assert @expect , "No output given"
      compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
      vool = compiler.ruby_to_vool(as_main)
      compiler.to_target(:interpreter)
    end
    def produce_main
      produce_target(:main)
    end
    def produce_block
      produce_target(:main_block)
    end
    def produce_target(name = :main_block)
      linker = to_target
      block = linker.assemblers.find {|c| c.callable.name == name }
      assert_equal Risc::Assembler , block.class
      block.instructions
    end
    def check_nil( name = :main )
      produced = produce_target( name )
      compare_instructions( produced , @expect )
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
      class_list(all.collect{|i| i.class})
    end
  end
end
