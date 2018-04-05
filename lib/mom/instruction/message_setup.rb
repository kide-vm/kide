module Mom

  # As reminder: a statically resolved call (the simplest one) becomes three Mom Instructions.
  # Ie: MessageSetup,ArgumentTransfer,SimpleCall
  #
  # MessageSetup does Setup before a call can be made, acquiring and filling the message
  # basically.Only after MessageSetup is the next_message safe to use.
  #
  # The space keeps a linked list of Messages, from which we take and currenty also return.
  #
  # Message setup set the name to the called method's name, and also set the arg and local
  # types on the new message, currently for debugging but later for dynamic checking
  #
  # The only difference between the setup of a static call and a dynamic one is where
  # the method comes from. A static, or simple call, passes the method, but a dynamic
  # call passes the cache_entry that holds the resolved method.
  #
  # In either case, the method is loaded and name,frame and args set
  #
  class MessageSetup < Instruction
    attr_reader :method_source

    def initialize(method_source)
      @method_source = method_source
    end

    # Move method name, frame and arguemnt types from the method to the next_message
    # Get the message from Space and link it.
    def to_risc(compiler)
      method = compiler.use_reg( :TypedMethod )
      risc = move_method_to(compiler , method)
      message = compiler.use_reg( :Message )
      risc << get_message_to(compiler , message)

      # move name args frame
      # this time using Risc instructions (create helpers?)
      name_move = SlotLoad.new( [:message , :next_message,:name] , [method_source , :name],self)
      moves = name_move.to_risc(compiler)
      args_move = SlotLoad.new( [:message , :next_message, :arguments, :type] , [method_source , :arguments_type],self)
      moves << args_move.to_risc(compiler)
      type_move = SlotLoad.new( [:message , :next_message, :frame, :type] , [method_source , :frame_type],self)
      moves << type_move.to_risc(compiler)
      return risc
    end
    private
    # get the method from method_source into the given register
    # return instruction that do this
    def move_method_to(compiler, register)
      Risc.load_constant("message setup move method" , @method_source ,register)
    end

    # get the next message from space and unlink it there
    # also put it into next_message of current message
    # use given message regster
    # return instructions to do this
    def get_message_to( compiler , message)
      Risc.load_constant("message setup move method" , @method_source ,message)
    end
  end


end
