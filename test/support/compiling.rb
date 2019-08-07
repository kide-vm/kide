
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
end
module VoolCompile
  include ScopeHelper
  include Mom

  def compile_vool_method(input)
    statements = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_vool(as_main(input))
    assert statements.is_a?(Vool::Statement) , statements.class
    statements
  end
  def compile_method(input)
    collection = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(input)
    assert collection.is_a?(Mom::MomCollection)
    compiler = collection.compilers.first
    assert compiler.is_a?(Mom::MethodCompiler)
    compiler
  end
  def compile_first_method( input )
    ret = compile_method( as_test_main( input ))
    assert_equal Mom::MethodCompiler , ret.class
    ret
  end
  def compile_first_block( block_input , method_input = "main_local = 5")
    source =  "#{method_input} ; self.main{|val| #{block_input}}"
    vool = Ruby::RubyCompiler.compile( as_test_main(source) ).to_vool
    mom_c = vool.to_mom(nil)
    compiler = mom_c.method_compilers.find{|c| c.get_method.name == :main and c.get_method.self_type.object_class.name == :Test}
    block = nil
    vool.each {|b| block = b if b.is_a?(Vool::BlockStatement)}
    assert block
    block_c = compiler.block_compilers.first
    assert block_c
    block.body.to_mom(block_c)
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

  def compile_method(input)
    statements = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_vool(input)
    assert statements.is_a?(Vool::ClassStatement)
    ret = statements.to_mom(nil)
    assert_equal Parfait::Class , statements.clazz.class , statements
    @method = statements.clazz.get_method(:main)
    assert_equal Parfait::VoolMethod , @method.class
    ret
  end
  def compile_first_method( input )
    ret = compile_method( as_test_main( input ))
    assert_equal Mom::MomCompiler , ret.class
    compiler = ret.method_compilers.find{|c| c.get_method.name == :main and c.get_method.self_type.object_class.name == :Test}
    assert_equal Risc::MethodCompiler , compiler.class
    @method.source.to_mom( compiler )
  end
  def compile_first_block( block_input , method_input = "main_local = 5")
    source =  "#{method_input} ; self.main{|val| #{block_input}}"
    vool = Ruby::RubyCompiler.compile( as_test_main(source) ).to_vool
    mom_c = vool.to_mom(nil)
    compiler = mom_c.method_compilers.find{|c| c.get_method.name == :main and c.get_method.self_type.object_class.name == :Test}
    block = nil
    vool.each {|b| block = b if b.is_a?(Vool::BlockStatement)}
    assert block
    block_c = compiler.block_compilers.first
    assert block_c
    block.body.to_mom(block_c)
  end
  def compile_mom(input)
    RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(input)
  end

end
