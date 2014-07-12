module Boot
  class String
    module ClassMethods
      def get context , index = Virtual::Integer
        get_function = Virtual::Method.new(:get , [ Virtual::Integer] , Virtual::Integer , Virtual::Integer )
        return get_function
      end
      def set context , index = Virtual::Integer , char = Virtual::Integer
        set_function = Virtual::Method.new(:set , [Virtual::Integer, Virtual::Integer] , Virtual::Integer ,Virtual::Integer )
        return set_function
      end
    end
    extend ClassMethods    
  end
end
