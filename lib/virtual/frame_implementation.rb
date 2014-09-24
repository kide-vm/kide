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
        next unless code.is_a?(NewFrame) or code.is_a?(NewMessage)
        new_codes = [  ]

        block.replace(code , new_codes )
      end
    end
  end
end
