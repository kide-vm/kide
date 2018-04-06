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
      builder = Risc::Builder.new(compiler)
      from = method_source
      risc = builder.build { typed_method << from }
      get_message_to(builder)

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
    def source
      "method setup "
    end

    # get the next message from space and unlink it there
    # also put it into next_message of current message
    # use given message register
    # return instructions to do this
    def get_message_to( builder )
      builder.build do
        space << Parfait.object_space
        space[:first_message] >> next_message
        #risc << Risc.slot_to_reg(source + "get next message" , space , :first_message , message)
      end
    end
    def nnop
      space = compiler.use_reg(:Space)
      risc = Risc.load_constant("message setup move method" , Parfait.object_space ,space)
      risc << Risc.slot_to_reg(source + "get next message" , space , :first_message , message)
      next_message = compiler.use_reg( :Message )
      risc << Risc.slot_to_reg(source + "get next message" , message , :next_message , next_message)
      risc << Risc.reg_to_slot(source + "store next message" , next_message , space , :first_message)
      risc << Risc.reg_to_slot(source + "store message in current" , message , :message , :next_message)
    end
  end


end
