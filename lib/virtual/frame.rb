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

    # 
    def compile_get name , method
      method.add FrameGet.new(name)
    end

    def compile_send name , method
      method.add FrameSend.new(name)
    end
  end
end
