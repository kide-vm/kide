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

    def each()
      yield self
    end

    def to_mom( _ )
      # temporary warning to find unimplemented kids
      raise "Not implemented for #{self}"
    end

    def ct_type
      nil
    end

  end

  class Expression

    def normalize
      raise "should not be normalized #{self}"
    end

  end

end


require_relative "statements/assign_statement"
require_relative "statements/array_statement"
require_relative "statements/basic_values"
require_relative "statements/class_statement"
require_relative "statements/hash_statement"
require_relative "statements/if_statement"
require_relative "statements/logical_statement"
require_relative "statements/local_assignment"
require_relative "statements/method_statement"
require_relative "statements/return_statement"
require_relative "statements/statements"
require_relative "statements/send_statement"
require_relative "statements/variables"
require_relative "statements/while_statement"
