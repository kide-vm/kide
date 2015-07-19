require_relative '../helper'
require 'parslet/convenience'


module CompilerHelper

  def check
    Virtual.machine.boot.compile_main @string_input
    produced = Virtual.machine.space.get_main.source
    assert_equal @output , produced
  end

end

class UnusedSofEquality
  # simple thought: don't recurse for Blocks, just check their names
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
      if( left.is_a? Block)
        return false unless left.name == right.name
      else
        return false unless left == right
      end
    end
    return true
  end
end
