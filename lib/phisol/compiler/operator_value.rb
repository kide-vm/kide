module Phisol
  Compiler.class_eval do

    def on_operator_value statement
      puts "operator #{statement.inspect}"
      operator , left_e , right_e = *statement
      # left and right must be expressions. Expressions return a register when compiled
      left_reg = process(left_e)
      right_reg = process(right_e)
      raise "Not register #{left_reg}" unless left_reg.is_a?(Register::RegisterValue)
      raise "Not register #{right_reg}" unless right_reg.is_a?(Register::RegisterValue)
      puts "left #{left_reg}"
      puts "right #{right_reg}"
      @method.source.add_code Register::OperatorInstruction.new(statement,operator,left_reg,right_reg)
      return left_reg # though this has wrong value attached
    end

    def on_assignment statement
      puts statement.inspect
      name , value = *statement
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
