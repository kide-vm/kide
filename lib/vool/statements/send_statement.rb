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
      receiver = @receiver.slot_class.new([:message , :next_message , :receiver] , @receiver)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index|
        args << arg.slot_class.new( arg_target + [index] , arg)
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
      create_tmps(in_method)
      Mom::Statements.new( cache_check(in_method) + call_cached_method(in_method) )
    end

    def flatten
      raise "flat"
    end
    # check that current type is the cached type
    # if not, change and find method for the type (simple_call to resolve_method)
    # conceptually easy in ruby, but we have to compile that "easy" ruby
    def cache_check(in_method)
      # return if cached_type == current_type
      # cached_type = current_type
      # cached_method = current_type.resolve_method(method.name)
      check = []
      cached_type = Mom::SlotDefinition.new(:message , [:frame , type_var_name])
      current_type = Mom::SlotDefinition.new(:message , [:self , :type])
      cond = Mom::NotSameCheck.new(cached_type , current_type)
      if_true =   nil #@if_true.to_mom( in_method ) #find and assign
      check << Mom::IfStatement.new(  cond , if_true )
      check
    end

    # this may look like a simple_call, but the difference is that we don't know
    # the method until run-time. Alas the setup is the same
    def call_cached_method(in_method)
      message_setup(in_method) << Mom::DynamicCall.new( method_var_name)
    end
    private
    # cached type and method are stored in the frame as local variables.
    # this creates the varables in the frame. Names are method_var_name and type_var_name
    def create_tmps(in_method)
      in_method.create_tmp
    end
    # we store the (one!) cached mathod in the frame, under the name that this
    # method returns
    def method_var_name
       "cached_method_#{object_id}"
    end
    def type_var_name
       "cached_type_#{object_id}"
    end
  end
end
