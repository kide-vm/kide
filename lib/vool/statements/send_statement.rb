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
      @dynamic = nil
    end

    def collect(arr)
      @receiver.collect(arr)
      @arguments.each do |arg|
        arg.collect(arr)
      end
      super
    end

    # A Send breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a CachedCall , or a SimpleCall, depending on wether the receiver type can be determined
    #
    # FIXME: we now presume direct (assignable) values for the arguments and receiver.
    #        in a not so distant future, temporary variables will have to be created
    #        and complex statements hoisted to assign to them. pps: same as in conditions
    def to_mom( in_method )
      if(@receiver.ct_type)
        simple_call(in_method)
      else
        cached_call(in_method)
      end
    end

    def message_setup(in_method)
      setup  = [Mom::MessageSetup.new(in_method)]
      receiver = @receiver.slot_class.new([:message , :next_message , :receiver] , @receiver.to_mom(in_method))
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index|
        args << arg.slot_class.new( arg_target + [index] , arg.to_mom(in_method))
      end
      setup << Mom::ArgumentTransfer.new( receiver , args )
    end

    def simple_call(in_method)
      type = @receiver.ct_type
      called_method = type.resolve_method(@name)
      raise "No method #{@name} for #{type}" unless called_method
      Mom::Statements.new( message_setup(in_method) << Mom::SimpleCall.new( called_method) )
    end

    # this breaks cleanly into two parts:
    # - check the cached type and if neccessary update
    # - call the cached method
    def cached_call(in_method)
      Mom::Statements.new( cache_check(in_method) + call_cached_method(in_method) )
    end

    # check that current type is the cached type
    # if not, change and find method for the type (simple_call to resolve_method)
    # conceptually easy in ruby, but we have to compile that "easy" ruby
    def cache_check(in_method)
      # if cached_type != current_type
      #   cached_type = current_type
      #   cached_method = current_type.resolve_method(method.name)
      if_true = Mom::Statements.new(build_type_cache_update)
      if_true.add_array build_method_cache_update(in_method)
      #@if_true.to_mom( in_method ) #find and assign
      [Mom::IfStatement.new( build_condition , if_true )]
    end

    # this may look like a simple_call, but the difference is that we don't know
    # the method until run-time. Alas the setup is the same
    def call_cached_method(in_method)
      @dynamic = Mom::DynamicCall.new()
      message_setup(in_method) << @dynamic
    end

    private
    def build_condition
      cached_type = Mom::SlotDefinition.new(@dynamic , [:cached_type])
      current_type = Mom::SlotDefinition.new(:message , [:receiver , :type])
      Mom::NotSameCheck.new(cached_type , current_type)
    end
    def build_type_cache_update
      [Mom::SlotMove.new([@dynamic, :cached_type] , [:receiver , :type])]
    end
    def build_method_cache_update(in_method)
      receiver = StringStatement.new(@name)
      resolve = SendStatement.new(:resolve_method , receiver , [SelfStatement.new])
      move_method = Mom::SlotMove.new([@dynamic, :cached_method] , [:receiver , :return])
      resolve.to_mom(in_method) << move_method
    end
  end
end
