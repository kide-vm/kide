
#TODO: get rid of this. along the Register.* functions

Virtual::MessageSlot.class_eval do
  def reg
    Register.message_reg
  end
end
Virtual::FrameSlot.class_eval do
  def reg
    Register.frame_reg
  end
end
Virtual::SelfSlot.class_eval do
  def reg
    Register.self_reg
  end
end
Virtual::NewMessageSlot.class_eval do
  def reg
    Register.new_message_reg
  end
end

module Register
  # This implements setting of the various slot variables the vm defines.
  # Basic mem moves, but have to shuffle the type nibbles (TODO!)

  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        # resolve the register and offset that we need to move to
        to = code.to.reg
        # need a temporay place because of indexed load/store
        tmp = Register.tmp_reg
        # for constants we have to "move" the constants value
        if( code.from.is_a?(Parfait::Value) or code.from.is_a?(Symbol))
          move1 = LoadConstant.new( code.from , tmp )
        else # while otherwise we "load"
          move1 = GetSlot.new( code.from.reg , get_index(code.from) , tmp )
        end
        move2 = SetSlot.new( tmp , to , get_index(code.to) )
        block.replace(code , [move1,move2] )
      end
    end

    def get_index from
      case from
      when Virtual::Self , Virtual::NewSelf
        return Register.resolve_index( :message , :receiver)
      when Virtual::MessageName , Virtual::NewMessageName
        return Register.resolve_index( :message , :name)
      when Virtual::NewArgSlot
        puts "from: #{from.index}"
        return Register.resolve_index( :message , :name) + 1 + from.index
      else
        raise "not implemented for #{from.class}"
      end
    end
  end
  Virtual.machine.add_pass "Register::SetImplementation"
end
