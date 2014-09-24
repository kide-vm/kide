module Virtual
  # So when an object calls a method, or sends a message, this is what it sends: a Message

  # A message contains the sender, return and exceptional return addresses,the arguments, and a slot for the frame.

  # As such it is a very run-time object, deep in the machinery as it were, and does not have meaningful
  # methods you could call at compile time.

  # The methods that are there, are nevertheless meant to be called at compile time and generate code, rather than
  # executing it.
  
  # The caller creates the Message and passes control to the receiver's method

  # The receiver create a new Frame to hold local and temporary variables and (later) creates default values for
  # arguments that were not passed

  # How the actual finding of the method takes place (acording to the ruby rules) is not simple, but as there is a 
  # guaranteed result (be it method_missing) it does not matter to the passing mechanism described

  # During compilation Message and frame objects are created to do type analysis

  class Message

    SELF_REG = :r0
    MESSAGE_REG = :r1
    FRAME_REG = :r2
    NEW_MESSAGE_REG = :r3

    TMP_REG = :r4
    
    def initialize me , normal , exceptional
      @me = me
      @next_normal = normal
      @next_exception = exceptional
      @arguments = arguments
      # a frame represents the local and temporary variables at a point in the program.
      @frame = nil
    end
    attr_reader :me, :next_normal, :next_exception, :arguments , :frame

    # dummy for the eventual
    def new_frame
      raise self.inspect
    end
    # 
    def compile_get method , name
      raise "CALLED"
      if method.has_arg(name)
        method.add_code MessageGet.new(name)
      else
        method.add_code FrameGet.new(name)
      end
      method.get_var(name)
    end

    def compile_set method , name , val
      method.set_var(name,val)
      if method.has_arg(name)
        method.add_code MessageSet.new(name , val )
      else
        method.add_code FrameSet.new(name , val )
      end
      method.get_var(name)
    end
  end
end
