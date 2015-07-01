
module Register
  # This implements setting of the various slot variables the vm defines.
  # Basic mem moves, but have to shuffle the type nibbles (TODO!)

  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        # need a temporay place because of indexed load/store
        tmp = Register.tmp_reg
        # for constants we have to "move" the constants value
        if( code.from.is_a?(Parfait::Value) or code.from.is_a?(Symbol))
          move1 = LoadConstant.new( code.from , tmp )
        else # while otherwise we "load"
          move1 = Register.get_slot( code.from.object_name , get_index(code.from) , tmp )
        end
        move2 = Register.set_slot( tmp , code.to.object_name , get_index(code.to) )
        block.replace(code , [move1,move2] )
      end
    end

    def get_index from
      case from
      when Virtual::Self , Virtual::NewSelf
        return Register.resolve_index( :message , :receiver)
      when Virtual::MessageMethod , Virtual::NewMessageMethod
        return Register.resolve_index( :message , :method)
      when Virtual::NewArgSlot
        puts "from: #{from.index}"
        return Register.resolve_index( :message , :method) + from.index
      else
        raise "not implemented for #{from.class}"
      end
    end
  end
  Virtual.machine.add_pass "Register::SetImplementation"
end
