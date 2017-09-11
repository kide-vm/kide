module Vool
  class SendStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    def collect(arr)
      @receiver.collect(arr)
      @arguments.each do |arg|
        arg.collect(arr)
      end
      super
    end

    # Sending in a dynamic language is off course not as simple as just calling.
    # The function that needs to be called depends after all on the receiver,
    # and no guarantees can be made on what that is.
    #
    # It helps to know that usually (>99%) the class of the receiver does not change.
    # Our stategy then is to cache the functions and only dynamically determine it in
    # case of a miss (the 1%, and first invocation)
    #
    # As cache key we must use the type of the object (which is the first word of _every_ object)
    # as that is constant, and function implementations depend on the type (not class)
    #
    # A Send breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a CachedCall , or a SimpleCall, depending on weather the receiver type can be determined
    #
    # FIXME: we now presume direct (assignable) values for the arguments and receiver.
    #        in a not so distant future, temporary variables will have to be created
    #        and complex statements hoisted to assign to them. pps: same as in conditions
    def to_mom( method )
      if(@receiver.ct_type)
        simple_call(method)
      else
        cached_call(method)
      end
    end

    def message_setup(method)
      setup  = [Mom::MessageSetup.new(method)]
      receiver = @receiver.slot_class.new([:message , :next_message , :receiver] , @receiver)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index|
        args << arg.slot_class.new( arg_target + [index] , arg)
      end
      setup << Mom::ArgumentTransfer.new( receiver , args )
    end

    def simple_call(method)
      type = @receiver.ct_type
      method = type.resolve_method(@name)
      raise "No method #{@name} for #{type}" unless method
      Mom::Statements.new( message_setup(method) << Mom::SimpleCall.new( method) )
    end

    def cached_call(method)
      raise "Not implemented #{method}"
      Mom::Statements.new( message_setup + call_instruction )
      [@receiver.slot_class.new([:message , :next_message , :receiver] , @receiver) ]
    end

  end
end
