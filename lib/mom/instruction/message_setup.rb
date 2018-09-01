module Mom

  # As reminder: a statically resolved call (the simplest one) becomes three Mom Instructions.
  # Ie: MessageSetup,ArgumentTransfer,SimpleCall
  #
  # MessageSetup does Setup before a call can be made, acquiring and filling the message
  # basically.Only after MessageSetup is the next_message safe to use.
  #
  # The Space keeps a linked list of Messages, from which we take and currenty also return.
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
      build_with(compiler.builder(self))
    end

    # directly called by to_risc
    # but also used directly in __init
    def build_with(builder)
      case from = method_source
      when Parfait::CallableMethod
        builder.build { callable! << from }
      when Parfait::CacheEntry
        builder.build do
          cache_entry! << from
          callable! << cache_entry[:cached_method]
        end
      when Integer
        builder.build do
          arguments! << message[:arguments]
          callable! << arguments[ from ]
        end
      else
        raise "unknown source #{method_source.class}:#{method_source}"
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
    # set the method into the message
    def build_message_data( builder )
      builder.build do
        factory? << Parfait.object_space.get_factory_for(:Message)
        next_message? << factory[:next_object]

        #FIXME in a multithreaded future this should be done using lock free compare and swap.
        next_message_reg! << next_message[:next_message]
        factory[:next_object] << next_message_reg

        message[:next_message] << next_message
        next_message[:caller] << message
        next_message[:method] << callable

      end
    end
  end
end
