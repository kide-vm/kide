
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

module MomCompile
  include ScopeHelper

  def compile_method(input)
    statements = RubyX::RubyXCompiler.new.ruby_to_vool(input)
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
    RubyX::RubyXCompiler.new.ruby_to_mom(input)
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




class Ignored
  def == other
    return false unless other.class == self.class
    Sof::Util.attributes(self).each do |a|
      begin
        left = send(a)
      rescue NoMethodError
        next  # not using instance variables that are not defined as attr_readers for equality
      end
      begin
        right = other.send(a)
      rescue NoMethodError
        return false
      end
      return false unless left.class == right.class
      return false unless left == right
    end
    return true
  end
end
