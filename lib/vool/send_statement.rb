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
    attr_reader :name , :receiver , :arguments , :block

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    def block
      return nil if arguments.empty?
      bl = arguments.last
      bl.is_a?(BlockStatement) ? bl : nil
    end

    def add_block( block )
      @arguments << block
    end

    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
    def each(&block)
      block.call(self)
      block.call(@receiver)
      @arguments.each do |arg|
        block.call(arg)
      end
      self.block.each(&block) if self.block
    end

    # lazy init this, to keep the dependency (which goes to parfait and booting) at bay
    def dynamic_call
      @dynamic ||= Mom::DynamicCall.new()
    end

    # A Send breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a CachedCall , or a SimpleCall, depending on wether the receiver type can be determined
    def to_mom( compiler )
      @receiver = SelfExpression.new(compiler.receiver_type) if @receiver.is_a?(SelfExpression)
      if(@receiver.ct_type)
        simple_call(compiler)
      else
        cached_call(compiler)
      end
    end

    # When used as right hand side, this tells what data to move to get the result into
    # a varaible. It is (off course) the return value of the message
    def slot_definition(compiler)
      Mom::SlotDefinition.new(:message ,[ :return_value])
    end

    def message_setup(compiler,called_method)
      setup  = Mom::MessageSetup.new( called_method )
      mom_receive = @receiver.slot_definition(compiler)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index| # +1 because of type
        args << Mom::SlotLoad.new( arg_target + [index + 1] , arg.slot_definition(compiler))
      end
      setup << Mom::ArgumentTransfer.new( mom_receive , args )
    end

    def simple_call(compiler)
      type = @receiver.ct_type
      called_method = type.resolve_method(@name)
      raise "No method #{@name} for #{type}" unless called_method
      message_setup(compiler,called_method) << Mom::SimpleCall.new(called_method)
    end

    # this breaks cleanly into two parts:
    # - check the cached type and if neccessary update
    # - call the cached method
    def cached_call(compiler)
      cache_check(compiler) << call_cached_method(compiler)
    end

    # check that current type is the cached type
    # if not, change and find method for the type (simple_call to resolve_method)
    # conceptually easy in ruby, but we have to compile that "easy" ruby
    def cache_check(compiler)
      ok = Mom::Label.new("cache_ok_#{self.object_id}")
      check = build_condition(ok, compiler)      # if cached_type != current_type
      check << Mom::SlotLoad.new([dynamic_call.cache_entry, :cached_type] , receiver_type_definition(compiler))
      check << Mom::ResolveMethod.new( @name , dynamic_call.cache_entry )
      check << ok
    end

    # to call the method (that we know now to be in the cache), we move the method
    # to reg1, do the setup (very similar to static) and call
    def call_cached_method(compiler)
      message_setup(compiler,dynamic_call.cache_entry) << dynamic_call
    end

    def to_s(depth = 0)
      sen = "#{receiver}.#{name}(#{@arguments.collect{|a| a.to_s}.join(', ')})"
      at_depth(depth , sen)
    end

    private
    def receiver_type_definition(compiler)
      defi = @receiver.slot_definition(compiler)
      defi.slots << :type
      defi
    end
    def build_condition(ok_label, compiler)
      cached_type = Mom::SlotDefinition.new(dynamic_call.cache_entry , [:cached_type])
      current_type = receiver_type_definition(compiler)
      Mom::NotSameCheck.new(cached_type , current_type, ok_label)
    end
  end
end
