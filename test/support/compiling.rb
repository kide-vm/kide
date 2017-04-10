
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
