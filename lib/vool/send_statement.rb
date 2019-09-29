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
  class SendStatement < CallStatement

    def block
      return nil if arguments.empty?
      bl = arguments.last
      bl.is_a?(LambdaExpression) ? bl : nil
    end

    def add_block( block )
      @arguments << block
    end

    def each(&block)
      super
      self.block.each(&block) if self.block
    end

    # lazy init this, to keep the dependency (which goes to parfait and booting) at bay
    def dynamic_call
      @dynamic ||= Mom::DynamicCall.new()
    end

    # A Send breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a CachedCall , or a SimpleCall, depending on wether the receiver type can be determined
    #
    # A slight complication occurs for methods defined in superclasses. Since we are
    # type, not class, based, these are not part of our type.
    # So we check, and if find, add the source (vool_method) to the class and start
    # compiling the vool for the receiver_type
    #
    def to_mom( compiler )
      @receiver = SelfExpression.new(compiler.receiver_type) if @receiver.is_a?(SelfExpression)
      if(@receiver.ct_type)
        method = @receiver.ct_type.get_method(@name)
        method = create_method_from_source(compiler) unless( method )
        return simple_call(compiler, method) if method
      end
      cached_call(compiler)
    end

    # If a method is found in the class (not the type)
    # we add it to the class that the receiver type represents, and create a compiler
    # to compile the vool for the specific type (the receiver)
    def create_method_from_source(compiler)
      vool_method = @receiver.ct_type.object_class.resolve_method!(@name)
      return nil unless vool_method
      puts "#{vool_method} , adding to #{@receiver.ct_type.object_class.name}"
      @receiver.ct_type.object_class.add_instance_method(vool_method)
      new_compiler = vool_method.compiler_for(@receiver.ct_type)
      compiler.add_method_compiler(new_compiler)
      new_compiler.callable
    end

    def message_setup(compiler,called_method)
      setup  = Mom::MessageSetup.new( called_method )
      mom_receive = @receiver.to_slot(compiler)
      arg_target = [:message , :next_message ]
      args = []
      @arguments.each_with_index do |arg , index| # +1 because of type
        args << Mom::SlotLoad.new(self, arg_target + ["arg#{index+1}".to_sym] , arg.to_slot(compiler))
      end
      setup << Mom::ArgumentTransfer.new(self, mom_receive , args )
    end

    def simple_call(compiler, called_method)
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
      ok = Mom::Label.new(self,"cache_ok_#{self.object_id}")
      check = build_condition(ok, compiler)      # if cached_type != current_type
      check << Mom::SlotLoad.new(self,[dynamic_call.cache_entry, :cached_type] , receiver_type_definition(compiler))
      check << Mom::ResolveMethod.new(self, @name , dynamic_call.cache_entry )
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
      defi = @receiver.to_slot(compiler)
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
