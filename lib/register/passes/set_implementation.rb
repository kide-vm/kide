Virtual::MessageSlot.class_eval do
  def reg
    Register::RegisterReference.message_reg
  end
end
Virtual::FrameSlot.class_eval do
  def reg
    Register::RegisterReference.frame_reg
  end
end
Virtual::SelfSlot.class_eval do
  def reg
    Register::RegisterReference.self_reg
  end
end
Virtual::NewMessageSlot.class_eval do
  def reg
    Register::RegisterReference.new_message_reg
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
        tmp = RegisterReference.tmp_reg
        # for constants we have to "move" the constants value
        if( code.from.is_a?(Parfait::Value) or code.from.is_a?(Symbol))
          move1 = LoadConstant.new( tmp , code.from )
        else # while otherwise we "load"
          move1 = GetSlot.new( tmp , code.from.reg , code.from.index )
        end
        move2 = SetSlot.new( tmp , to , code.to.index )
        block.replace(code , [move1,move2] )
      end
    end
  end
  Virtual.machine.add_pass "Register::SetImplementation"
end
