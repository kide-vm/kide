module Boot
  class String
    module ClassMethods
      def get context , index = Vm::Integer
        get_function = Vm::Function.new(:get , Vm::Integer , [ Vm::Integer] , Vm::Integer )
        return get_function
      end
      def set context , index = Vm::Integer , char = Vm::Integer
        set_function = Vm::Function.new(:set , Vm::Integer ,[Vm::Integer, Vm::Integer] , Vm::Integer )
        return set_function
      end
    end
    extend ClassMethods    
  end
end
