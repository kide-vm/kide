module Register
  module Builtin
    module Word
      module ClassMethods
        def putstring context
          compiler = Soml::Compiler.new.create_method(:Word , :putstring ).init_method
          compiler.add_code Register.get_slot( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RegisterValue.new(:r2 , :Integer)
          compiler.add_code Register.get_slot( "putstring" , :new_message , index , reg )
          Kernel.emit_syscall( compiler , :putstring )
          compiler.method
        end
      end
      extend ClassMethods
    end
  end
end
