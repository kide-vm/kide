require "ast/sexp"

module Register
  module Builtin
    class Object
      module ClassMethods
        include AST::Sexp

        # main entry point, ie __init__ calls this
        # defined here as empty, to be redefined
        def main context
          compiler = Soml::Compiler.new.create_method(:Object , :main , []).init_method
          return compiler.method
        end

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        # (this method returns a new method off course, like all builting)
        def get_internal context
          compiler = Soml::Compiler.new.create_method(:Object , :get_internal , []).init_method
          source = "get_internal"
          #Load self by "calling" on_name
          me = compiler.process( s(:name , :self) )
          # Load the argument
          index = compiler.use_reg :Integer
          compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(1), index )
          # reduce me to me[index]
          compiler.add_code  GetSlot.new( source , me , index , me)
          # and put it back into the return value
          compiler.add_code Register.set_slot( source , me , :message , :return_value)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end

require_relative "integer"
require_relative "kernel"
require_relative "word"
