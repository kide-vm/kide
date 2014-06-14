require_relative "code"
require_relative "register_reference"

module Vm
  
  # Values represent the information as it is processed. Different subclasses for different types, 
  # each type with different operations.
  # The oprerations on values is what makes a machine do things. Operations are captured as 
  # subclasses of Instruction and saved to Blocks
  
  # Values are a way to reason about (create/validate) instructions. 
  
  # Word Values are what fits in a register. Derived classes
  # Float, Reference , Integer(s) must fit the same registers
  
  # just a base class for data. not sure how this will be usefull (may just have read too much llvm)
  class Value 
    def class_for clazz
      RegisterMachine.instance.class_for(clazz)
    end
  end

  # Just a nice way to write branches
  # Comparisons produce them, and branches take them as argument.
  class BranchCondition < Value

    def initialize operator
      @operator = operator
    end
    attr_accessor :operator
    #needed to check the opposite, ie not true
    def not_operator
      case @operator
      when :le
        :gt
      when :gt
        :le
      when :lt
        :ge
      when :eq
        :ne
      else
        raise "no implemented #{@operator}"
      end
    end
  end
end
require_relative "values/constants"
require_relative "values/word"
require_relative "values/integer"
require_relative "values/reference"
require_relative "values/mystery"
