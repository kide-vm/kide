require_relative "builtin/compile_helper"
require_relative "builtin/space"
require_relative "builtin/integer"
require_relative "builtin/object"
require_relative "builtin/word"

module Risc
  module Builtin
    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name.
    # This should return the implementation of the method (ie a method object),
    # not actually try to implement it(as that's impossible in ruby)
    #
    # When no main has been compiled, we will add an empty main (for testing)
    #
    def self.boot_functions(add_main = false)
      # TODO go through the virtual parfait layer and adjust function names
      #      to what they really are
      compilers = []
      space = Parfait.object_space
      space_type = space.get_class.instance_type
      if(space_type.methods.nil?)
        compilers << compiler_for( space_type   , Space , :main)
      end

      obj_type = space.get_class_by_name(:Object).instance_type
      [ :get_internal_word , :set_internal_word , :_method_missing,
        :exit , :__init__].each do |f|
        compilers << compiler_for( obj_type , Object , f)
      end

      word_type = space.get_class_by_name(:Word).instance_type
      [:putstring , :get_internal_byte , :set_internal_byte ].each do |f|
        compilers << compiler_for( word_type , Word , f)
      end

      int_type = space.get_class_by_name(:Integer).instance_type
      Risc.operators.each do |op|
        compilers << operator_compiler( int_type , op)
      end
      [:putint, :div4, :div10 , :<,:<= , :>=, :>].each do |f|   #div4 is just a forward declaration
        compilers << compiler_for( int_type , Integer , f)
      end
      compilers
    end

    def self.compiler_for( type , mod , name)
      compiler = mod.send(name , nil)
      type.add_method( compiler.method )
      compiler
    end
    def self.operator_compiler(int_type , op)
      compiler = Integer.operator_method(op)
      int_type.add_method(compiler.method)
      compiler
    end
  end
end
