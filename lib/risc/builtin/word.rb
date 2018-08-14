module Risc
  module Builtin
    module Word
      module ClassMethods
        include CompileHelper

        # wrapper for the syscall
        # io/file currently hardcoded to stdout
        # set up registers for syscall, ie
        # - pointer in r1
        # - length in r2
        # - emit_syscall (which does the return of an integer, see there)
        def putstring( context)
          compiler = compiler_for(:Word , :putstring ,{})
          builder = compiler.compiler_builder(compiler.source)
          new_message = Risc.message_reg.get_new_left(:receiver , compiler)
          builder.add_slot_to_reg( "putstring" , Risc.message_reg , :receiver , new_message )
          index = Parfait::Word.get_length_index
          index_reg = RegisterValue.new(:r2 , :Integer)
          builder.add_slot_to_reg( "putstring" , new_message , index , index_reg )
          Risc::Builtin::Object.emit_syscall( builder , :putstring )
          compiler.add_mom( Mom::ReturnSequence.new)
          compiler
        end

        # self[index] basically. Index is the first arg > 0
        # return a word sized new int, in return_value
        def get_internal_byte( context)
          compiler = compiler_for(:Word , :get_internal_byte , {at: :Integer})
          compiler.compiler_builder(compiler.source).build do
            object! << message[:receiver]
            integer! << message[:arguments]
            integer << integer[1]
            integer.reduce_int
            object <= object[integer]
            add_new_int("get_internal_byte", object , integer)
            message[:return_value] << integer
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # return value
        def set_internal_byte( context )
          compiler = compiler_for(:Word, :set_internal_byte , {at: :Integer , :value => :Integer} )
          compiler.compiler_builder(compiler.source).build do
            word! << message[:receiver]
            integer! << message[:arguments]
            integer << integer[1]
            integer_reg! << message[:arguments]
            integer_obj! << integer_reg[2]
            integer_reg << integer_reg[2]
            integer.reduce_int
            integer_reg.reduce_int
            word[integer] <= integer_reg
            message[:return_value] << integer_obj
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

      end
      extend ClassMethods
    end
  end
end
