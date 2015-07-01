module Register
  module Builtin
    module Word
      module ClassMethods
        def putstring context
          function = Virtual::CompiledMethodInfo.create_method(:Word , :putstring , [] )
          Kernel.emit_syscall( function , :putstring )
          function
        end
      end
      extend ClassMethods
    end
  end
end
