# Virtual
# Object Oriented
# Language
#
# VOOL is the abstraction of ruby, ruby minusthe fluff
#      fluff is generally what makes ruby nice to use, like 3 ways to achieve the same thing
#      if/unless/ternary , reverse ifs (ie statement if condition), reverse whiles,
#      implicit blocks, splats and multiple assigns etc
#
# Also, Vool is a typed tree, not abstract, so  there is a base class Statement
#            and all it's derivation that make up the syntax tree
#
# Also Vool has expression and statements, revealing that age old dichotomy of code and
# data. Statements represent code whereas Expressions resolve to data.
# (in ruby there are no pure statements, everthing resolves to data)
module Vool

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Basically Statements represent code, generally speaking code "does things".
  # But Vool distinguishes Expressions (see below), that represent data, and as such
  # don't do things themselves, rather passively participate in being pushed around
  class Statement

    def to_mom( _ )
      # temporary warning to find unimplemented kids
      raise "Not implemented for #{self}"
    end

    def at_depth(depth , lines)
      prefix = " " * 2 * depth
      strings = lines.split("\n")
      strings.collect{|str| prefix + str}.join("\n")
    end

  end

  # An Expression is a Statement that represents data. ie variables constants
  # (see basic_values) , but alos classes, methods and lambdas
  class Expression < Statement

    def each(&block)
      block.call(self)
    end

    def ct_type
      nil
    end

    def normalize
      raise "should not be normalized #{self}"
    end

    # for loading into a slot, return the "slot_definition" that can be passed to
    # SlotLoad.
    def to_slot(compiler)
      raise "not iplemented in #{self}"
    end

  end

end


require_relative "assignment"
require_relative "basic_values"
require_relative "call_statement"
require_relative "class_expression"
require_relative "if_statement"
require_relative "ivar_assignment"
require_relative "lambda_expression"
require_relative "local_assignment"
require_relative "macro_expression"
require_relative "method_expression"
require_relative "class_method_expression"
require_relative "return_statement"
require_relative "statements"
require_relative "send_statement"
require_relative "super_statement"
require_relative "variables"
require_relative "while_statement"
require_relative "yield_statement"
