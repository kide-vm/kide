
module CompilerHelper

  def in_Test(statements)
    "class Test ; #{statements} ; end"
  end

  def in_Space(statements)
    "class Space ; #{statements} ; end"
  end

  def as_main(statements)
    in_Space("def main ; #{statements}; end")
  end

  def as_test_main( statements )
    in_Test("def main(arg) ; #{statements}; end")
  end
end

module MomCompile
  include CompilerHelper

  def compile_first_method input
    lst = Vool::VoolCompiler.ruby_to_vool as_test_main( input )
    assert_equal Parfait::Class , lst.clazz.class , input
    @method = lst.clazz.get_method(:main)
    assert_equal Parfait::VoolMethod , @method.class
    res = lst.to_mom( nil )
    #puts "#{res.class}"
    res.first
  end

  def compile_first_method_flat(input)
    compile_first_method(input).flatten
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
    "[#{res.join(',')}]"
  end

end


module CleanCompile
  def clean_compile(clazz_name , method_name , args , statements)
    compiler = Vm::MethodCompiler.create_method(clazz_name,method_name,args ).init_method
    compiler.process( Vm.ast_to_code( statements ) )
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
