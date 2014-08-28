module Salama
  module Kernel
    def self.putstring context 
      function = Virtual::CompiledMethod.new(:putstring , [] )
      return function
      ret = Virtual::RegisterMachine.instance.write_stdout(function)
      function.set_return ret
      function
    end
  end
  class String
    module ClassMethods
      def get context , index = Virtual::Integer
        get_function = Virtual::CompiledMethod.new(:get , [ Virtual::Integer] , Virtual::Integer , Virtual::Integer )
        return get_function
      end
      def set context , index = Virtual::Integer , char = Virtual::Integer
        set_function = Virtual::CompiledMethod.new(:set , [Virtual::Integer, Virtual::Integer] , Virtual::Integer ,Virtual::Integer )
        return set_function
      end
      def puts context 
        puts_function = Virtual::CompiledMethod.new(:puts , []  )
        return puts_function
      end
    end
    extend ClassMethods    
  end
end
