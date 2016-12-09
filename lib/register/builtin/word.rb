module Register
  module Builtin
    module Word
      module ClassMethods
        include AST::Sexp

        def putstring context
          compiler = Typed::Compiler.new.create_method(:Word , :putstring ).init_method
          compiler.add_code Register.get_slot( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RegisterValue.new(:r2 , :Integer)
          compiler.add_code Register.get_slot( "putstring" , :new_message , index , reg )
          Kernel.emit_syscall( compiler , :putstring )
          compiler.method
        end
        
        # self[index] basically. Index is the first arg > 0
        # return (and word sized int) is stored in return_value
        def get_internal_byte context
          compiler = Typed::Compiler.new.create_method(:Word , :get_internal_byte , {:index => :Integer }).init_method
          source = "get_internal_word"
          #Load self by "calling" on_name
          me = compiler.process( Typed::Tree::NameExpression.new( :self) )
          # Load the argument
          index = compiler.use_reg :Integer
          compiler.add_code Register.get_slot(source , :message , Parfait::Message.get_indexed(1), index )
          # reduce me to me[index]
          compiler.add_code GetByte.new( source , me , index , me)
          # and put it back into the return value
          compiler.add_code Register.set_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # no return
        def set_internal_byte context
          compiler = Typed::Compiler.new.create_method(:Word , :set_internal_byte ,
                                                {:index => :Integer, :value  => :Integer } ).init_method
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
          compiler.add_code SetByte.new( source , value , me , index)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
