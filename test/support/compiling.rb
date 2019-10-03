require_relative "preloader"

module ScopeHelper

  def compiler_with_main(options = {})
    compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options.merge(options))
    compiler.ruby_to_sol( "class Space;def main(arg);return;end;end" )
    compiler
  end
  def in_Test(statements)
    "class Test ; #{statements} ; end"
  end

  def as_test_main(statements)
    in_Test("def main(arg) ; #{statements}; end")
  end

  def in_Space(statements)
    "class Space ; #{statements} ; end"
  end

  def as_main(statements)
    in_Space("def main(arg) ; #{statements}; end")
  end

  def as_main_block( block_input = "return 5", method_input = "main_local = 5")
    as_main("#{method_input} ; self.main{|val| #{block_input}}")
  end

end
module SolCompile
  include ScopeHelper
  include SlotMachine
  include Preloader

  def compile_main( input , preload = nil)
    input = get_preload(preload) + as_main( input )
    collection = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(input)
    assert collection.is_a?(SlotMachine::SlotCollection) , collection.class.name
    compiler = collection.compilers.find_compiler_name(:main)
    assert_equal SlotMachine::MethodCompiler , compiler.class
    compiler
  end
  def compile_main_block( block_input , method_input = "main_local = 5" , preload = nil)
    source = get_preload(preload) + as_main("#{method_input} ; self.main{|val| #{block_input}}")
    slot_col = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot( source )
    compiler = slot_col.method_compilers.find_compiler_name(:main)
    block = slot_col.method_compilers.find_compiler_name(:main_block)
    assert block
    block.slot_instructions.next
  end
  def check_array( should , is )
    index = 0
    test = is
    while(test)
      # if we assert here, we get output pointing here. Without stack, not useful
      raise "Wrong class for #{index+1}, #{dump(is)}" if should[index] != test.class
      index += 1
      test = test.next
    end
    assert 1  #just to get an assertion in the output.
  end
  def dump(is)
    res =[]
    while(is)
      res << is.class.name.split("::").last
      is = is.next
    end
    ret = ""
    res.to_s.split(",").each_slice(5).each do |line|
      ret += "                   " + line.join(",") + " ,\n"
    end
    ret.gsub('"' , '')
  end

end

module SlotMachineCompile
  include ScopeHelper

  def compile_slot(input)
    RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(input)
  end

end
