module Phisol
  Compiler.class_eval do

      #    attr_reader  :name
      # compiling name needs to check if it's a variable and if so resolve it
      # otherwise it's a method without args and a send is issued.
      # whichever way this goes the result is stored in the return slot (as all compiles)
      def on_name statement
        name = statement.to_a.first
        return Virtual::Self.new( Phisol::Reference.new(@clazz)) if name == :self
        # either an argument, so it's stored in message
        if( index = @method.has_arg(name))
          type = @method.arguments[index].type
          return Virtual::ArgSlot.new(index , type )
        else # or a local so it is in the frame
          index = @method.has_local( name )
          if(index)
            type = @method.locals[index].type
            return Virtual::FrameSlot.new(index, type )
          end
        end
        raise "must define variable #{name} before using it"
      end

  end #module
end
