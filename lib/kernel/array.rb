module Salama
  class Array
    module ClassMethods
      def get context , index = Virtual::Integer
        get_function = Virtual::CompiledMethod.new(:get , [ Virtual::Integer] , Virtual::Integer , Virtual::Integer )
        return get_function
      end
      def set context , index = Virtual::Integer , object = Virtual::Reference
        set_function = Virtual::CompiledMethod.new(:set , [Virtual::Integer, Virtual::Reference] )
        return set_function
      end
      def push context , object = Virtual::Reference
        push_function = Virtual::CompiledMethod.new(:push , [Virtual::Reference]  )
        return push_function
      end
    end
    extend ClassMethods    
  end
end
