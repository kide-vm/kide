module Phisol
  Compiler.class_eval do

    def on_operator statement
      puts "operator #{statement.inspect}"
      operator , left_e , right_e = *statement
      left_slot = process(left_e)
      right_slot = process(right_e)
      puts "left #{left_slot}"
      puts "right #{right_slot}"
      tmp1 = Register.tmp_reg
      tmp2 = tmp1.next_reg_use
      get = Register.get_slot_to(statement , left_slot , tmp1 )
      get2 = Register.get_slot_to(statement , right_slot , tmp2 )
      puts "GET #{get}"
      puts "GET2 #{get2}"
      @method.source.add_code get
      @method.source.add_code get2

      @method.source.add_code Register::OperatorInstruction.new(statement,operator, tmp1,tmp2)

      Virtual::Return.new(:int )
    end

    def on_assign statement
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
