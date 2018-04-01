module Risc
  module Builtin
    module Word
      module ClassMethods
        include CompileHelper

        def putstring context
          compiler = compiler_for(:Word , :putstring ,{})
          compiler.add_slot_to_reg( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RiscValue.new(:r2 , :Integer)
          compiler.add_slot_to_reg( "putstring" , :new_message , index , reg )
          Kernel.emit_syscall( compiler , :putstring )
          compiler.method
        end

        # self[index] basically. Index is the first arg > 0
        # return (and word sized int) is stored in return_value
        def get_internal_byte context
          compiler = compiler_for(:Word , :get_internal_byte , {at: :Integer})
          source = "get_internal_byte"
          me , index = compiler.self_and_int_arg(source)
          # reduce me to me[index]
          compiler.add_byte_to_reg( source , me , index , me)
          # and put it back into the return value
          compiler.add_reg_to_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # no return
        def set_internal_byte context
          compiler = compiler_for(:Word, :set_internal_byte , {at: :Integer , :value => :Integer} )
          args = compiler.method.arguments
          len = args.instance_length
          raise "Compiler arg number mismatch, method=#{args} " if  len != 3
          source = "set_internal_byte"
          me , index = compiler.self_and_int_arg(source)
          value = compiler.load_int_arg_at(source , 2 )
          # do the set
          compiler.add_reg_to_byte( source , value , me , index)
          return compiler.method
        end

        # resolve the method name of self, on the given object
        # may seem wrong way around at first sight, but we know the type of string. And
        # thus resolving this method happens at compile time, whereas any method on an
        # unknown self (the object given) needs resolving and that is just what we are doing
        #  ( ie the snake bites it's tail)
        # This method is just a placeholder until boot is over and the real method is
        # parsed.
        def resolve_method context
          compiler = compiler_for(:Word, :resolve_method , {:value => :Object} )
          args = compiler.method.arguments
          len = args.instance_length
          raise "Compiler arg number mismatch, method=#{args} " if  len != 2
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
