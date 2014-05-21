module Vm
  # Base class for anything that we can assemble

  # Derived classes include instructions and data(values)
  
  # The commonality abstracted here is the length and position
  # and the ability to assemble itself into the stream
  
  # All code is position independant once assembled.
  # But for jumps and calls two passes are neccessary. 
  # The first setting the position, the second assembling
  class Code
    
    def class_for clazz
      CMachine.instance.class_for(clazz)
    end

    # set the position to zero, will have to reset later
    def initialize
      @position = 0
    end

    # the position in the stream. Think of it as an address if you want. The difference is small.
    # Especially since we produce _only_ position independant code
    # in other words, during assembly the position _must_ be resolved into a pc relative address
    # and not used as is
    def position
      @position 
    end
    
    # The containing class (assembler/function) call this to tell the instruction/data where it is in the
    # stream. During assembly the position is then used to calculate pc relative addresses.
    def link_at address , context
      @position = address
    end
    
    # length for this code in bytes
    def length
      raise "Not implemented #{inspect}"
    end
    
    # so currently the interface passes the io (usually string_io) in for the code to assemble itself.
    # this may change as the writing is still done externally (or that will change)
    def assemble(io)
      raise "Not implemented #{self.inspect}"
    end
  end
end