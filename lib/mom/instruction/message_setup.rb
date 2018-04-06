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
      build_message_data(builder)
      compiler.reset_regs
      return risc
    end
    private
    def source
      "method setup "
    end

    # get the next message from space and unlink it there
    # also put it into next_message of current message
    def build_message_data( builder )
      builder.build do
        space << Parfait.object_space
        next_message << space[:first_message]
        message[:next_message] << next_message
        next_message[:caller] << message

        named_list << next_message[:arguments]
        type << typed_method[:arguments_type]
        named_list[:type] << type

        named_list << next_message[:frame]
        type << typed_method[:arguments_type]
        named_list[:type] << type

        name << typed_method[:arguments_type]
        named_list[:type] << name

        #store next.next back into space
        next_message << next_message[:next_message]
        space[:first_message] << next_message
      end
    end
  end
end
