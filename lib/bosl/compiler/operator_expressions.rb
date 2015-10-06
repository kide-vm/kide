module Bosl
  Compiler.class_eval do
#    operator attr_reader  :operator, :left, :right
    def on_operator expression
      operator , left , right = *expression
      #raise "not quite there"
      Virtual::Return.new(:int)
    end

    def on_assign expression
      puts expression.inspect
      name , value = *expression
      name = name.to_a.first
      v = process(value)
      index = @method.has_local( name )
      if(index)
        @method.source.add_code Virtual::Set.new(Virtual::FrameSlot.new(index, :int ) , v )
      else
        index = @method.has_arg( name )
        if(index)
          @method.source.add_code Virtual::Set.new(Virtual::ArgSlot.new(index , :int ) , v )
        else
          raise "must define variable #{name} before using it in #{@method.inspect}"
        end
      end
    end

  end
end
