module SlotMachine

  # As reminder: a statically resolved call (the simplest one) becomes three SlotMachine Instructions.
  # Ie: MessageSetup,ArgumentTransfer,SimpleCall
  #
  # MessageSetup does Setup before a call can be made, acquiring and filling the message
  # basically. Only after MessageSetup is the next_message safe to use.
  #
  # The Factory (instane kept by Space) keeps a linked list of Messages,
  # from which we take and currenty also return.
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
      raise "no nil source" unless method_source
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
        callable = builder.load_object(from)
      when Parfait::CacheEntry
        callable = builder.load_object(from)[:cached_method].to_reg
      when Integer
        callable = builder.message[ "arg#{from}".to_sym ].to_reg
      else
        raise "unknown source #{method_source.class}:#{method_source}"
      end
      build_message_data(builder , callable)
      return builder.built
    end

    private
    def source
      "method setup "
    end

    # set the method into the message
    def build_message_data( builder , callable)
      builder.message[:next_message][:method] << callable
    end
  end
end
