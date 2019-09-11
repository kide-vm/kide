module Mom
  module Builtin
    module CompileHelper

      def compiler_for( clazz_name , method_name , arguments , locals = {})
        frame = Parfait::NamedList.type_for( locals )
        args = Parfait::NamedList.type_for( arguments )
        Mom::MethodCompiler.compiler_for_class(clazz_name , method_name , args, frame )
      end
    end
  end
  class Macro < Instruction
  end
end

require_relative "macro/space"
require_relative "macro/integer"
require_relative "macro/object"
require_relative "macro/word"

module Mom
  module Builtin
    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name.
    # This should return the implementation of the method (ie a method compiler),
    # not actually try to implement it(as that's impossible in ruby)
    #
    # We create an empty main for init to jump to, if no code is compiled, that just returns
    # See Builtin directory readme and module
    def self.boot_functions( options = nil)
      space = Parfait.object_space
      space_type = space.get_class.instance_type

      if @compilers and options == nil
        if(space_type.methods.nil?)
          @compilers << compiler_for( space_type   , Space , :main)
        end
        return @compilers
      end
      # TODO go through the virtual parfait layer and adjust function names
      #      to what they really are
      @compilers = []

      obj_type = space.get_type_by_class_name(:Object)
      [ :__init__ , :exit ,  :_method_missing, :get_internal_word ,
        :set_internal_word ].each do |f|
        @compilers << compiler_for( obj_type , Object , f)
      end

      word_type = space.get_type_by_class_name(:Word)
      [:putstring , :get_internal_byte , :set_internal_byte ].each do |f|
        @compilers << compiler_for( word_type , Word , f)
      end

      int_type = space.get_type_by_class_name(:Integer)
      Risc.operators.each do |op|
        @compilers << operator_compiler( int_type , op)
      end
      [ :div4, :<,:<= , :>=, :> , :div10 ].each do |f|   #div4 is just a forward declaration
        @compilers << compiler_for( int_type , Integer , f)
      end
      return @compilers
    end

    def self.compiler_for( type , mod , name)
      compiler = mod.send(name , nil)
      compiler.add_method_to(type)
      compiler
    end
    def self.operator_compiler(int_type , op)
      compiler = Integer.operator_method(op)
      compiler.add_method_to(int_type)
      compiler
    end
  end
end
