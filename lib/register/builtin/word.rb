module Register
  module Builtin
    module Word
      module ClassMethods
        def putstring context
          function = MethodSource.create_method(:Word , :putstring , [] )
          function.source.add_code Register.get_slot( function , :message , :receiver , :new_message )
          Kernel.emit_syscall( function , :putstring )
          function
        end
      end
      extend ClassMethods
    end
  end
end
