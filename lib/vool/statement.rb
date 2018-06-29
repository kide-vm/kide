# Virtual
# Object Oriented
# Language
#
# VOOL is the abstraction of ruby, ruby minus some of the fluff
#      fluff is generally what makes ruby nice to use, like 3 ways to achieve the same thing
#      if/unless/ternary , reverse ifs (ie statement if condition), reverse whiles,
#      implicit blocks, splats and multiple assigns etc
#
# Also, Vool is a typed tree, not abstract, so  there is a base class Statement
#            and all it's derivation that make up the syntax tree
#
# Also Vool has expression and statements and simple syntax. So returns must be explicit
# not everthing is just assignable, ifs can only test simple expressions etc (wip)
#
# This allows us to write compilers or passes of the compiler(s) as functions on the
# classes.
#
module Vool

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Compilers or compiler passes are written by implementing methods.
  #
  class Statement

    # after creation vool normalizes to ensure valid syntax and simplify
    # also throw errors if violation
    def normalize()
      raise self.class.name
    end

    def to_mom( _ )
      # temporary warning to find unimplemented kids
      raise "Not implemented for #{self}"
    end

  end

  class Expression

    def ct_type
      nil
    end

    def normalize
      raise "should not be normalized #{self}"
    end
    def to_mom(method)
      raise "should not be momed #{self}"
    end

    # for loading into a lot, return the "slot_definition" that can be passed to
    # SlotLoad.
    def slot_definition(method)
      raise "not iplemented in #{self}"
    end

  end

end


require_relative "assign_statement"
require_relative "array_statement"
require_relative "basic_values"
require_relative "block_statement"
require_relative "class_statement"
require_relative "hash_statement"
require_relative "if_statement"
require_relative "logical_statement"
require_relative "local_assignment"
require_relative "method_statement"
require_relative "return_statement"
require_relative "statements"
require_relative "send_statement"
require_relative "variables"
require_relative "while_statement"
require_relative "yield_statement"
