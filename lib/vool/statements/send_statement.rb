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
      statements = Statements.new([])
      arguments = []
      @arguments.each_with_index do |arg , index |
        normalize_arg(arg , arguments , statements)
      end
      if statements.empty?
        return SendStatement.new(@name, @receiver , @arguments)
      else
        statements << SendStatement.new(@name, @receiver , arguments)
        return statements
      end
    end

    def normalize_arg(arg , arguments , statements)
      if arg.respond_to?(:slot_definition) and !arg.is_a?(SendStatement)
        arguments << arg
        return
      end
      assign = LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, arg)
      statements << assign
      arguments << LocalVariable.new(assign.name)
    end

    def to_s
      "#{receiver}.#{name}(#{arguments.join(',')})"
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

    def message_setup(in_method,called_method)
      setup  = Mom::MessageSetup.new( called_method )
      mom_receive = @receiver.slot_definition(in_method)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index| # +1 because of type
        args << Mom::SlotLoad.new( arg_target + [index + 1] , arg.slot_definition(in_method))
      end
      setup << Mom::ArgumentTransfer.new( mom_receive , args )
    end

    def simple_call(in_method)
      type = @receiver.ct_type
      called_method = type.resolve_method(@name)
      raise "No method #{@name} for #{type}" unless called_method
      message_setup(in_method,called_method) << Mom::SimpleCall.new(called_method)
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
      ok = Mom::Label.new("cache_ok_#{self.object_id}")
      check = build_condition(ok, in_method)      # if cached_type != current_type
      check << Mom::SlotLoad.new([dynamic_call.cache_entry, :cached_type] , receiver_type_definition(in_method))
      check << Mom::ResolveMethod.new( @name , dynamic_call.cache_entry )
      check << ok
    end

    # to call the method (that we know now to be in the cache), we move the method
    # to reg1, do the setup (very similar to static) and call
    def call_cached_method(in_method)
      message_setup(in_method,dynamic_call.cache_entry) << dynamic_call
    end

    private
    def receiver_type_definition(in_method)
      defi = @receiver.slot_definition(in_method)
      defi.slots << :type
      defi
    end
    def build_condition(ok_label, in_method)
      cached_type = Mom::SlotDefinition.new(dynamic_call.cache_entry , [:cached_type])
      current_type = receiver_type_definition(in_method)
      Mom::NotSameCheck.new(cached_type , current_type, ok_label)
    end
  end
end
