module Virtual
  # This implements the creation of new frame and message object

  # Frames and Message are very similar apart from the class name
  # - All existing instances are stored in the space for both
  # - Size is currently 2, ie 16 words (TODO a little flexibility here would not hurt, but the mountain is big)
  # - Unused instances for a linked list with their first instance variable. This is HARD coded to avoid any lookup
  
  # Just as a reminder: a message object is created before a send and holds return address/message and arguemnts + self
  # frames are created upon entering a method and hold local and temporary variables
  # as a result one of each is created for every single method call. A LOT, so make it fast luke
  # Note: this is off course the reason for stack based implementations that just increment a known pointer/register or
  #       something. But i think most programs are memory bound and a few extra instructions don't hurt. 
  #       After all, we are buying a big prize:oo, otherwise known as sanity.

  class FrameImplementation
    def run block
      block.codes.dup.each do |code|
        if code.is_a?(NewFrame) 
          kind = :next_frame
        elsif code.is_a?(NewMessage)
          kind = :next_message
        else
          next
        end
        space = BootSpace.space
        machine = Register::RegisterMachine.instance
        slot = Virtual::Slot
        space_tmp = Register::RegisterReference.new(Virtual::Message::TMP_REG)
        frame_tmp = space_tmp.next_reg_use
        new_codes = [ machine.mov( frame_tmp , space )]
        ind = space.layout[:names].index(kind)
        new_codes << machine.ldr( frame_tmp , frame_tmp , ind)
        block.replace(code , new_codes )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after  FrameImplementation , GetImplementation
end
