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
          compiler.add_code Putstring.new("putstring")
          return compiler
        end
        class Putstring < ::Mom::Instruction
          def to_risc(compiler)
            builder = compiler.builder(compiler.source)
            builder.prepare_int_return # makes integer_tmp variable as return
            builder.build do
              word! << message[:receiver]
              integer! << word[Parfait::Word.get_length_index]
            end
            Risc::Builtin.emit_syscall( builder , :putstring )
            compiler
          end
        end
        # self[index] basically. Index is the first arg > 0
        # return a word sized new int, in return_value
        #
        # Note: no index (or type) checking. Method should be internal and check before.
        #       Which means the returned integer could be passed in, instead of allocated.
        def get_internal_byte( context)
          compiler = compiler_for(:Word , :get_internal_byte , {at: :Integer})
          compiler.add_code GetInternalByte.new("get_internal_byte")
          return compiler
        end
        class GetInternalByte < ::Mom::Instruction
          def to_risc(compiler)
            builder = compiler.builder(compiler.source)
            integer_tmp = builder.allocate_int
            builder.build do
              object! << message[:receiver]
              integer! << message[:arguments]
              integer << integer[Parfait::NamedList.type_length + 0] #"at" is at index 0
              integer.reduce_int
              object <= object[integer]
              integer_tmp[Parfait::Integer.integer_index] << object
              message[:return_value] << integer_tmp
            end
            return compiler
          end
        end
        # self[index] = val basically. Index is the first arg ( >0 , unchecked),
        # value the second, which is also returned
        def set_internal_byte( context )
          compiler = compiler_for(:Word, :set_internal_byte , {at: :Integer , value: :Integer} )
          compiler.add_code SetInternalByte.new("set_internal_byte")
          return compiler
        end
        class SetInternalByte < ::Mom::Instruction
          def to_risc(compiler)
            compiler.builder(compiler.source).build do
              word! << message[:receiver]
              integer! << message[:arguments]
              integer_reg! << integer[Parfait::NamedList.type_length + 1] #"value" is at index 1
              message[:return_value] << integer_reg
              integer << integer[Parfait::NamedList.type_length + 0] #"at" is at index 0
              integer.reduce_int
              integer_reg.reduce_int
              word[integer] <= integer_reg
            end
            return compiler
          end
        end
      end
      extend ClassMethods
    end
  end
end
