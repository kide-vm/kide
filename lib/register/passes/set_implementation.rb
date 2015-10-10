
module Register
  # This implements setting of the various slot variables the vm defines.

  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        # need a temporay place because of indexed load/store
        tmp = Register.tmp_reg :int
        # for constants we have to "move" the constants value
        if( code.from.is_a?(Parfait::Value) or code.from.is_a?(Symbol) or code.from.is_a?(Fixnum) )
          move1 = LoadConstant.new(code, code.from , tmp )
        else # while otherwise we "load"
          puts "from #{code.from}"
          move1 = Register.get_slot(code, code.from.object_name , get_index(code.from) , tmp )
        end
        #puts "to #{code.to}"
        move2 = Register.set_slot( code , tmp , code.to.object_name , get_index(code.to) )
        block.replace(code , [move1,move2] )
      end
    end

    def get_index from
      case from
      when Virtual::Self , Virtual::NewSelf
        return Register.resolve_index( :message , :receiver)
      when Virtual::MessageName , Virtual::NewMessageName
        return Register.resolve_index( :message , :name)
      when Virtual::Return
        return Register.resolve_index( :message , :return_value)
      when Virtual::ArgSlot , Virtual::NewArgSlot
        #puts "from: #{from.index}"
        return Register.resolve_index( :message , :name) + from.index
      when Virtual::FrameSlot
        #puts "from: #{from.index}"
        return Register.resolve_index( :frame , :next_frame) + from.index
      else
        raise "not implemented for #{from.class}"
      end
    end
  end
  Virtual.machine.add_pass "Register::SetImplementation"
end
