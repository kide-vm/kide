
module ScopeHelper

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
  include ScopeHelper

  def compile_first_method( input )
    # works a lot like Vool.ruby_to_vool
    # but here we return the intermediate mom instructions that are otherwise not available
    statements = RubyX::RubyCompiler.compile as_test_main( input )
    statements = statements.normalize
    res = statements.to_mom(nil)
    assert_equal Parfait::Class , statements.clazz.class , statements
    @method = statements.clazz.get_method(:main)
    assert_equal Parfait::VoolMethod , @method.class
    #puts "#{res.class}"
    res
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
