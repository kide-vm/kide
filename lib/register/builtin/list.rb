module Register
  module Builtin
    # This is all fantasy at the moment. Not even required, not tested, just an idea
    # Most likely wrong, in fact so old as to predate the internal_XX stuff
    class List
      module ClassMethods
        def get context , index = Virtual::Integer
          get_function = Virtual::CompiledMethodInfo.create_method(:get , [ Virtual::Integer] , Virtual::Integer , Virtual::Integer )
          return get_function
        end
        def set context , index = Virtual::Integer , object = Virtual::Reference
          set_function = Virtual::CompiledMethodInfo.create_method(:set , [Virtual::Integer, Virtual::Reference] )
          return set_function
        end
        def push context , object = Virtual::Reference
          push_function = Virtual::CompiledMethodInfo.create_method(:push , [Virtual::Reference]  )
          return push_function
        end
      end
      extend ClassMethods
    end
  end
end
