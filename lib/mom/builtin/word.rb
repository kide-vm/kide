require_relative "get_internal_byte"
require_relative "set_internal_byte"
require_relative "putstring"

module Mom
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
        # self[index] = val basically. Index is the first arg ( >0 , unchecked),
        # value the second, which is also returned
        def set_internal_byte( context )
          compiler = compiler_for(:Word, :set_internal_byte , {at: :Integer , value: :Integer} )
          compiler.add_code SetInternalByte.new("set_internal_byte")
          return compiler
        end
      end
      extend ClassMethods
    end
  end
end
