module Vool
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
  class SendStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    def normalize
      #TODO normalize arguments. In first stage args must be variables or hoisted (like while/if)
      #   later sends ok, but then they must execute
      #   (currently we only use the args as slot_definition so they are not "momed")
      @arguments.each_with_index do |arg , index |
        raise "arg #{index} does not provide slot definition #{arg}" unless arg.respond_to?(:slot_definition)
        raise "Sends not implemented yet at #{index}:#{arg}" if arg.is_a?(SendStatement)
      end
      SendStatement.new(@name, @receiver , @arguments)
    end

    def each(&block)
      block.call(self)
      block.call(@receiver)
      @arguments.each do |arg|
        block.call(arg)
      end
    end

    # lazy init this, to keep the dependency (which goes to parfait and booting) at bay
    def dynamic_call
      @dynamic ||= Mom::DynamicCall.new()
    end

    # A Send breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a CachedCall , or a SimpleCall, depending on wether the receiver type can be determined
    #
    # FIXME: we now presume direct (assignable) values for the arguments and receiver.
    #        in a not so distant future, temporary variables will have to be created
    #        and complex statements hoisted to assign to them. pps: same as in conditions
    def to_mom( in_method )
      @receiver = SelfExpression.new(in_method.for_type) if @receiver.is_a?(SelfExpression)
      if(@receiver.ct_type)
        simple_call(in_method)
      else
        cached_call(in_method)
      end
    end

    # When used as right hand side, this tells what data to move to get the result into
    # a varaible. It is (off course) the return value of the message
    def slot_definition(in_method)
      Mom::SlotDefinition.new(:message ,[ :return_value])
    end

    def message_setup(in_method)
      setup  = Mom::MessageSetup.new(in_method)
      mom_receive = @receiver.slot_definition(in_method)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index|
        args << Mom::SlotLoad.new( arg_target + [index] , arg.slot_definition(in_method))
      end
      setup << Mom::ArgumentTransfer.new( mom_receive , args )
    end

    def simple_call(in_method)
      type = @receiver.ct_type
      called_method = type.resolve_method(@name)
      raise "No method #{@name} for #{type}" unless called_method
      message_setup(in_method) << Mom::SimpleCall.new( called_method)
    end

    # this breaks cleanly into two parts:
    # - check the cached type and if neccessary update
    # - call the cached method
    def cached_call(in_method)
      cache_check(in_method) << call_cached_method(in_method)
    end

    # check that current type is the cached type
    # if not, change and find method for the type (simple_call to resolve_method)
    # conceptually easy in ruby, but we have to compile that "easy" ruby
    def cache_check(in_method)
      # if cached_type != current_type
      #   cached_type = current_type
      #   cached_method = current_type.resolve_method(method.name)
      check = build_condition
      check << build_type_cache_update
      check << build_method_cache_update(in_method)
    end

    # this may look like a simple_call, but the difference is that we don't know
    # the method until run-time. Alas the setup is the same
    def call_cached_method(in_method)
      message_setup(in_method) << dynamic_call
    end

    private
    def build_condition
      cached_type = Mom::SlotDefinition.new(dynamic_call.cache_entry , [:cached_type])
      current_type = Mom::SlotDefinition.new(:message , [:receiver , :type])
      Mom::NotSameCheck.new(cached_type , current_type)
    end
    def build_type_cache_update
      Mom::SlotLoad.new([dynamic_call.cache_entry, :cached_type] , [:message , :receiver , :type])
    end
    def build_method_cache_update(in_method)
      receiver = StringConstant.new(@name)
      resolve = SendStatement.new(:resolve_method , receiver , [SelfExpression.new])
      move_method = Mom::SlotLoad.new([dynamic_call.cache_entry, :cached_method] , [:message , :return_value])
      resolve.to_mom(in_method) << move_method
    end
  end
end
