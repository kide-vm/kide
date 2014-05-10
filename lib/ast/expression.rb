# abstract syntax tree (ast)
# This Layer is semi automagically created by parslet using the transform

# It in turn is responsible for the transformation to the next layer, vm code

# This happens in the compile function which must return a Vm::Code derivative

# PS: compare is only for tests and should be factored out to there

module Ast
  class Expression
    def eval 
      raise "abstract #{self}"
    end
    def compile context
      raise "abstract #{self}"
    end
    def inspectt
      self.class.name + ".new(" + self.attributes.collect{|m| self.send(m).inspect }.join( ",") +")"
    end
    def attributes
      raise "abstract #{self}"
    end
    def == other
      return false unless other.class == self.class 
      attributes.each do |a|
        left = send(a)
        right = other.send( a)
        return false unless left.class == right.class 
        return false unless left == right
      end
      return true
    end
  end

end

require_relative "basic_expressions"
require_relative "conditional_expression"
require_relative "function_expression"
require_relative "operator_expressions"