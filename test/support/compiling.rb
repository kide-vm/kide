
module ScopeHelper

  def in_Test(statements)
    "class Test ; #{statements} ; end"
  end

  def in_Space(statements)
    "class Space ; #{statements} ; end"
  end

  def as_main(statements)
    in_Space("def main(arg) ; #{statements}; end")
  end

  def as_test_main( statements )
    in_Test("def main(arg) ; #{statements}; end")
  end

  def as_test_main_block( block_input = "return 5", method_input = "main_local = 5")
    as_test_main("#{method_input} ; self.main{|val| #{block_input}}")
  end

end
module VoolCompile
  include ScopeHelper
  include Mom


  def compile_first_method( input )
    inut = as_test_main( input )
    collection = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(input)
    assert collection.is_a?(Mom::MomCollection)
    compiler = collection.compilers.first
    assert compiler.is_a?(Mom::MethodCompiler)
    assert_equal Mom::MethodCompiler , compiler.class
    compiler
  end
  def compile_first_block( block_input , method_input = "main_local = 5")
    source =  "#{method_input} ; self.main{|val| #{block_input}}"
    risc_col = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_risc( as_test_main(source) )
    compiler = risc_col.method_compilers.find{|c| c.get_method.name.to_s.start_with?("implicit") }
    assert_equal 1 , compiler.class
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

module MomCompile
  include ScopeHelper

  def compile_mom(input)
    RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(input)
  end

end
