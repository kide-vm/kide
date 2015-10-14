module Register
  module Builtin
    module Word
      module ClassMethods
        def putstring context
          function = Virtual::MethodSource.create_method(:Word,:Integer , :putstring , [] )
          Kernel.emit_syscall( function , :putstring )
          function
        end
      end
      extend ClassMethods
    end
  end
end
