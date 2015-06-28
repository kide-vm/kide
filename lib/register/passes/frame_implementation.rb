module Register
  # This implements the creation of new frame and message object

  # Frames and Message are very similar apart from the class name
  # - All existing instances are stored in the space for both
  # - Size is currently 2, ie 16 words
  #        (TODO a little flexibility here would not hurt, but the mountain is big)
  # - Unused instances for a linked list with their first instance variable.
  #      This is HARD coded to avoid any lookup

  # Just as a reminder: a message object is created before a send and holds return address/message
  # and arguments + self frames are created upon entering a method and hold local and temporary
  # variables as a result one of each is created for every single method call.
  #  A LOT, so make it fast luke
  # Note: this is off course the reason for stack based implementations that just increment
  #        a known pointer/register or something. But i think most programs are memory bound
  #        and a few extra instructions don't hurt.
  #       After all, we are buying a big prize:oo, otherwise known as sanity.

  # TODO: This is too complicated, which means it should be ruby code and "inlined"
  #       then it would move to Virtual
  class FrameImplementation
    def run block
      block.codes.dup.each do |code|
        if code.is_a?(Virtual::NewFrame)
          kind = :next_frame
        elsif code.is_a?(Virtual::NewMessage)
          kind = :next_message
        else
          next
        end
        # a place to store a reference to the space, we grab the next_frame from the space
        space_tmp = RegisterReference.tmp_reg
        # move the spave to it's register (mov instruction gets the address of the object)
        new_codes = [ LoadConstant.new( Parfait::Space.object_space , space_tmp )]
        # find index in the space where to grab frame/message
        space_index = Parfait::Space.object_space.get_layout().index_of( kind )
        raise "index not found for #{kind}.#{kind.class}" unless space_index
        # load the frame/message from space by index
        new_codes << GetSlot.new( space_tmp , space_index , RegisterReference.frame_reg )
        # a temporary place to store the new frame
        frame_tmp = space_tmp.next_reg_use
        # get the next_frame
        from = Parfait::Space.object_space.send( kind )
        kind_index = from.get_layout().index_of( kind )
        raise "index not found for #{kind}.#{kind.class}" unless kind_index
        new_codes << GetSlot.new( RegisterReference.frame_reg , kind_index , frame_tmp) # 2 index of next_frame
        # save next frame into space
        new_codes << SetSlot.new( frame_tmp , space_tmp , space_index)
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::FrameImplementation"
end
