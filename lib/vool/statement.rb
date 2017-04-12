# Virtual
# Object Oriented
# Langiage
#
# VOOL is the abstraction of ruby, ruby minus some of the fluff
#      fluff is generally what makes ruby nice to use, like 3 ways to achieve the same thing
#      if/unless/ternary , reverse ifs (ie statement if condition), reverse whiles,
#      implicit blocks, splats and multiple assigns etc
#
# Also, Vool is a typed tree, not abstract, so  there is a base class Statement
#            and all it's derivation that make up the syntax tree
#
# This allows us to write compilers or passes of the compiler(s) as functions on the
# classes.
module Vool

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Compilers or compiler passes are written by implementing methods.
  #
  class Statement

    def collect(arr)
      arr << self
    end

    def to_mom( _ )
      # temporary warning to find unimplemented kids
      raise "Not implemented for #{self}"
    end

    # create corresponding parfait objects, ie classes, types, methods
    # mainly implemented by class/method statement
    def create_objects
    end

    # used to collect type information
    def add_ivar( array )
    end

    # used to collect frame information
    def add_local( array )
    end

    # used for method creation
    def set_class( clazz )
    end
  end
end


require_relative "statements/array_statement"
require_relative "statements/basic_values"
require_relative "statements/class_statement"
require_relative "statements/hash_statement"
require_relative "statements/if_statement"
require_relative "statements/ivar_statement"
require_relative "statements/logical_statement"
require_relative "statements/local_statement"
require_relative "statements/method_statement"
require_relative "statements/return_statement"
require_relative "statements/statements"
require_relative "statements/send_statement"
require_relative "statements/variables"
require_relative "statements/while_statement"
