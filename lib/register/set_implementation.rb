Virtual::MessageSlot.class_eval do
  def reg
    Register::RegisterReference.new(Virtual::Message::MESSAGE_REG )
  end
end
Virtual::FrameSlot.class_eval do
  def reg
    Register::RegisterReference.new(Virtual::Message::FRAME_REG )
  end
end
Virtual::SelfSlot.class_eval do
  def reg
    Register::RegisterReference.new(Virtual::Message::SELF_REG )
  end
end
Virtual::NewMessageSlot.class_eval do
  def reg
    Register::RegisterReference.new(Virtual::Message::NEW_MESSAGE_REG )
  end
end

module Register
  # This implements setting of the various slot variables the vm defines. 
  # Basic mem moves, but have to shuffle the type nibbles
  
  class SetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::Set
        # resolve the register and offset that we need to move to
        to = code.to.reg
        # need a temporay place because of indexed load/store
        tmp = RegisterReference.new(Virtual::Message::TMP_REG)
        # for constants we have to "move" the constants value
        if( code.from.is_a? Virtual::Constant)
          move1 = RegisterMachine.instance.mov( tmp , code.from )
        else # while otherwise we "load"
          move1 = RegisterMachine.instance.ldr( tmp , code.from.reg , code.from.index )
        end
        move2 = RegisterMachine.instance.str( tmp , to , code.to.index )
        block.replace(code , [move1,move2] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after SetImplementation , Virtual::GetImplementation
end
