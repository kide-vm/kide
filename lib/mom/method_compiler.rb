module Mom

  # MethodCompiler is used to generate Mom instructions for methods
  # and to instantiate the methods correctly.

  class MethodCompiler < CallableCompiler

    def initialize( method )
      super(method)
    end

    def source_name
      "#{@callable.self_type.name}.#{@callable.name}"
    end

    def get_method
      @callable
    end

    # sometimes the method is used as source (tb reviewed)
    def source
      @callable
    end

    # drop down to risc by converting this compilers instructions to risc.
    # and the doing the same for any block_compilers
    def to_risc
      risc_compiler = Risc::MethodCompiler.new(@callable , mom_instructions)
      instructions_to_risc(risc_compiler)
      risc_compiler
    end

    # helper method for builtin mainly
    # the class_name is a symbol, which is resolved to the instance_type of that class
    #
    # return compiler_for_type with the resolved type
    #
    def self.compiler_for_class( class_name , method_name , args , frame )
      raise "create_method #{class_name}.#{class_name.class}" unless class_name.is_a? Symbol
      clazz = Parfait.object_space.get_class_by_name! class_name
      compiler_for_type( clazz.instance_type , method_name , args , frame)
    end

    def add_method_to( target )
      target.add_method( @callable )
    end

    def create_block(arg_type , frame_type)
      @callable.create_block(arg_type ,frame_type)
    end

    # create a method for the given type ( Parfait type object)
    # method_name is a Symbol
    # args a hash that will be converted to a type
    # the created method is set as the current and the given type too
    # return the compiler
    def self.compiler_for_type( type , method_name , args , frame)
      raise "create_method #{type.inspect} is not a Type" unless type.is_a? Parfait::Type
      raise "Args must be Type #{args}" unless args.is_a?(Parfait::Type)
      raise "create_method #{method_name}.#{method_name.class}" unless method_name.is_a? Symbol
      method = type.create_method( method_name , args , frame)
      self.new(method)
    end

    # determine how given name need to be accsessed.
    # For methods the options are args or frame
    def slot_type_for(name)
      if index = @callable.arguments_type.variable_index(name)
        return ["arg#{index}".to_sym]
      end
      index = @callable.frame_type.variable_index(name)
      raise "no such local or argument #{name} for #{callable.name}:#{callable.frame_type.hash}" unless index
      return ["local#{index}".to_sym]
    end

    # return true or false if the given name is in scope (arg/local)
    def in_scope?(name)
      ret = true if @callable.arguments_type.variable_index(name)
      ret = @callable.frame_type.variable_index(name) unless ret
      ret
    end

    # Only for init, as init has no return
    # kind of private
    def _reset_for_init
      @mom_instructions = Label.new(source_name, source_name)
      @current = @mom_instructions
    end

  end
end
