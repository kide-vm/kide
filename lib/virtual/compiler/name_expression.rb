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
          ret = Return.new
          if( index = method.has_arg(name))
            method.source.add_code Set.new( ArgSlot.new(index ) , ret)
          else # or a local so it is in the frame
            index = method.ensure_local( name )
            method.source.add_code Set.new(FrameSlot.new(index ) , ret )
          end
          return ret
        else
          call = Ast::CallSiteExpression.new(expression.name , [] ) #receiver self is implicit
          Compiler.compile(call, method)
        end
      end

  end #module
end
