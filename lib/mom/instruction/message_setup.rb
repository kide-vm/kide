module Mom

  # As reminder: a statically resolved call (the simplest one) becomes three Mom Instructions.
  # Ie: MessageSetup,ArgumentTransfer,SimpleCall
  #
  # MessageSetup does Setup before a call can be made, acquiring and filling the message
  # basically.
  #
  # With the current design the next message is already ready (hardwired as a linked list),
  # so nothing to be done there.
  # (but this does not account for continuations or closures and so will have to be changed)
  #
  # But we do need to set the message name to the called method's name,
  # and also set the arg and local types on the new message, currently for debugging
  # but later for dynamic checking
  #
  class MessageSetup < Instruction
    attr_reader :method

    def initialize(method)
        @method = method
    end

    # Move method name, frame and arguemnt types from the method to the neext_message
    # Assumes the message is ready, see class description
    def to_risc(compiler)
      name_move = SlotLoad.new( [:message , :next_message,:name] , [method , :name],self)
      moves = name_move.to_risc(compiler)
      args_move = SlotLoad.new( [:message , :next_message, :arguments,:type] , [method , :arguments, :type],self)
      moves << args_move.to_risc(compiler)
      type_move = SlotLoad.new( [:message , :next_message, :frame,:type] , [method , :frame,:type],self)
      moves << type_move.to_risc(compiler)
    end

  end


end
