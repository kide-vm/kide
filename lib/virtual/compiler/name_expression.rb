module Virtual
  module Compiler

      #    attr_reader  :name
      # compiling name needs to check if it's a variable and if so resolve it
      # otherwise it's a method without args and a send is issued.
      # whichever way this goes the result is stored in the return slot (as all compiles)
      def self.compile_name expression , method
        return Self.new( Reference.new(method.for_class)) if expression.name == :self
        name = expression.name.to_sym
        if method.has_var(name)
          # either an argument, so it's stored in message
          if( index = method.has_arg(name))
            method.source.add_code Set.new( MessageSlot.new(expression.name) , Return.new)
          else # or a local so it is in the frame
            method.source.add_code FrameGet.new(expression.name , index)
          end
        else
          call = Ast::CallSiteExpression.new(expression.name , [] ) #receiver self is implicit
          Compiler.compile(call, method)
        end
      end

  end #module
end
