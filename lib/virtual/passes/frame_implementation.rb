module Virtual
  # This implements the creation of new frame and message object

  # Frames and Message are very similar apart from the class name
  # - All existing instances are stored in the space for both
  # - Size is currently 2, ie 16 words
  #        (TODO a little flexibility here would not hurt, but the mountain is big)
  # - Unused instances for a linked list with their first instance variable.
  #      This is HARD coded to avoid any lookup

  # Just as a reminder: a message object is created before a send and holds return address/message
  # and arguemnts + self frames are created upon entering a method and hold local and temporary
  # variables as a result one of each is created for every single method call.
  #  A LOT, so make it fast luke
  # Note: this is off course the reason for stack based implementations that just increment
  #        a known pointer/register or something. But i think most programs are memory bound
  #        and a few extra instructions don't hurt.
  #       After all, we are buying a big prize:oo, otherwise known as sanity.

  class FrameImplementation
    def run block
      block.codes.dup.each do |code|
        if code.is_a?(NewFrame)
          kind = "next_frame"
        elsif code.is_a?(NewMessage)
          kind = "next_message"
        else
          next
        end
        # a place to store a reference to the space, we grab the next_frame from the space
        space_tmp = Register::RegisterReference.tmp_reg
        # a temporary place to store the new frame
        frame_tmp = space_tmp.next_reg_use
        # move the spave to it's register (mov instruction gets the address of the object)
        new_codes = [ Register::LoadConstant.new( space_tmp , Parfait::Space.object_space )]
        # find index in the space where to grab frame/message
        ind = Parfait::Space.object_space.get_layout().index_of( kind )
        raise "index not found for #{kind}.#{kind.class}" unless ind
        # load the frame/message from space by index
        new_codes << Register::GetSlot.new( frame_tmp , space_tmp , 5 )
        # save the frame in real frame register
        new_codes << Register::RegisterTransfer.new( Register::RegisterReference.frame_reg , frame_tmp )
        # get the next_frame
        new_codes << Register::GetSlot.new( frame_tmp , frame_tmp , 2 ) # 2 index of next_frame
        # save next frame into space
        new_codes << Register::SetSlot.new( frame_tmp , space_tmp , ind)
        block.replace(code , new_codes )
      end
    end
  end
  Virtual::Machine.instance.add_pass "Virtual::FrameImplementation"
end
