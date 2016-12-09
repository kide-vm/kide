require "ast/sexp"

module Register
  module Builtin
    class Object
      module ClassMethods
        include AST::Sexp

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        # (this method returns a new method off course, like all builtin)
        def get_internal_word context
          compiler = Typed::Compiler.new.create_method(:Object , :get_internal_word , {:index => :Integer}).init_method
          source = "get_internal_word"
          #Load self by "calling" on_name
          me = compiler.process( Typed::Tree::NameExpression.new( :self) )
          # Load the argument
          index = compiler.use_reg :Integer
          compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(1), index )
          # reduce me to me[index]
          compiler.add_code  GetSlot.new( source , me , index , me)
          # and put it back into the return value
          compiler.add_code Register.set_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg , value the second
        # no return
        def set_internal_word context
          compiler = Typed::Compiler.new.create_method(:Object , :set_internal_word ,
                                                {:index => :Integer, :value => :Object} ).init_method
          source = "set_internal_word"
          #Load self by "calling" on_name
          me = compiler.process( Typed::Tree::NameExpression.new( :self) )
          # Load the index
          index = compiler.use_reg :Integer
          compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(1), index )
          # Load the value
          value = compiler.use_reg :Integer
          compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(2), value )
          # do the set
          compiler.add_code SetSlot.new( source , value , me , index)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
