module Virtual
  # A frame, or activation frame, represents a function call during calling. So not the static definition of the function
  # but the dynamic invokation of it.
  #
  # In a minimal c world this would be just the return address, but with exceptions and continuations things get more
  # complicated. How much more we shall see
  #
  # The current list comprises
  # - next normal instruction
  # - next exception instruction
  # - self (me)
  # - argument mappings
  # - local variable mapping, together with last called binding
  class Frame
    def initialize normal , exceptional , me
      @next_normal = normal
      @next_exception = exceptional
      @me = me
      # a binding represents the local variables at a point in the program.
      # The amount of local variables is assumed to be relatively small, and so the 
      # storage is a linked list. Has the same api as a ha
      @binding = List.new
    end
    attr_reader :next_normal, :next_exception, :me, :binding

    # dummy for the eventual
    def new_frame
      self
    end
    # 
    def compile_get method , name
      method.add FrameGet.new(name)
      method.get_var(name)
    end

    def compile_send method , name , with = [] 
      method.add FrameSend.new(name , with )
      Return.new( method.return_type )
    end

    def compile_set method , name , val
      method.add FrameSet.new(name , val )
      method.get_var(name)
    end
  end
end
