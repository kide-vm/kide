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
      builder = compiler.code_builder(self)
      build_with(builder)
    end

    # directly called by to_risc
    # but also used directly in __init
    def build_with(builder)
      case from = method_source
      when Parfait::TypedMethod
        builder.build { typed_method << from }
      when Parfait::CacheEntry
        builder.build do
          cache_entry << from
          typed_method << cache_entry[:cached_method]
        end
      else
        raise "unknown source #{method_source}"
      end
      build_message_data(builder)
      return builder.built
    end

    private
    def source
      "method setup "
    end

    # get the next message from space and unlink it there
    # also put it into next_message of current message (and reverse)
    # set name and type data in the message, from the method loaded
    def build_message_data( builder )
      builder.build do
        space << Parfait.object_space
        next_message << space[:next_message]
        message[:next_message] << next_message
        next_message[:caller] << message

        type << typed_method[:arguments_type]
        named_list << next_message[:arguments]
        named_list[:type] << type

        type << typed_method[:frame_type]
        named_list << next_message[:frame]
        named_list[:type] << type

        name << typed_method[:name]
        next_message[:name] << name

        #store next.next back into space
        #FIXME in a multithreaded future this should be done soon after getting
        #   the first_message, using lock free compare and swap. Now saving regs
        next_message << next_message[:next_message]
        space[:next_message] << next_message
      end
    end
  end
end
