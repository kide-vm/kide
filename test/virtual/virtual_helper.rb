require_relative '../helper'
require 'parslet/convenience'
require "yaml"

Parfait::Object.class_eval do
  def secret_layout_hammer
    internal_object_set(Parfait::Object::LAYOUT_INDEX , nil)
  end
end

module VirtualHelper
  # need a code generator, for arm
  def setup
#    @object_space = Boot::Space.new "Arm"
  end

  def check
    machine = Virtual::Machine.boot
    expressions = machine.compile_main @string_input
    if( expressions.first.is_a? Parfait::Method )
      # stops the whole objectspace beeing tested
      # with the class comes superclass and all methods
      expressions.first.instance_variable_set :@for_class , nil
      expressions.first.secret_layout_hammer
      expressions.first.code.secret_layout_hammer
    end
    if( expressions.first.is_a? Virtual::Self )
      # stops the whole objectspace beeing tested
      # with the class comes superclass and all methods
      expressions.first.type.instance_variable_set :@of_class , nil
    end
    is = Sof.write(expressions)
    #puts is
    is.gsub!("\n" , "*^*")
    assert_equal @output , is
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
