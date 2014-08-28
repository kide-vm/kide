module Salama
  class Object
    module ClassMethods
    
      # return the index of the variable. Now "normal" code can't really do anything with that, but 
      # set/get instance variable use it. 
      # This is just a placeholder, as we code this in ruby, but the instance methods need the definition before.
      def index_of context , name = Virtual::Integer
        index_function = Virtual::CompiledMethod.new(:index_of , Virtual::Reference , [Virtual::Reference] , Virtual::Integer )
        return index_function
      end

      def self.layout
        layout_function = Virtual::Function.new(:layout , [ ] , Virtual::Reference  , Virtual::Reference )
        layout_function.at_index 2
        layout_function
      end

      # in ruby, how this goes is   
      #  def _get_instance_variable var
      #     i = self.index_of(var)
      #     return at_index(i)
      #  end  
      # The at_index is just "below" the api, something we need but don't want to expose, so we can't code the above in ruby
      def _get_instance_variable context , name = Virtual::Integer
        get_function = Virtual::CompiledMethod.new(:_get_instance_variable , [ Virtual::Reference ] , Virtual::Reference ,Virtual::Mystery )
        return get_function
        me = get_function.receiver
        var_name = get_function.args.first
        return_to = get_function.return_type

        index_function = context.object_space.get_or_create_class(:Object).resolve_function(:index_of)
        get_function.push( [me] )
        index = get_function.call( index_function )
        
        after_body = get_function.new_block("after_index")
        get_function.current after_body
        
        get_function.pop([me])
        return_to.at_index( get_function , me , return_to )
        
        get_function.set_return return_to
        return get_function
      end

      def _set_instance_variable(context , name = Virtual::Integer , value = Virtual::Integer )
        set_function = Virtual::CompiledMethod.new(:_set_instance_variable ,[Virtual::Reference ,Virtual::Reference], Virtual::Reference ,Virtual::Mystery )
        return set_function
        receiver set_function
        me = set_function.receiver
        var_name = set_function.args.first
        return_to = set_function.return_type
        index_function = context.object_space.get_or_create_class(:Object).resolve_function(:index_of)
        set_function.push( [me] )
        set_function.call( index_function )
        after_body = set_function.new_block("after_index")
        
        set_function.current after_body
        set_function.pop([me])
        return_to.at_index( set_function , me , return_to )
        set_function.set_return return_to
        return set_function
      end
      
      def _get_singleton_method(context , name )
        raise name
      end
      def _add_singleton_method(context, method)
        raise "4"
      end
      def initialize(context)
        raise "4"
      end
    end
    extend ClassMethods
  end
end
