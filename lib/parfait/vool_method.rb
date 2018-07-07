module Parfait

  # This represents the method at source code level (sis vool)
  #
  # Type objects are already created for args and locals, but the main attribute
  # is the source, which is a Vool::Statement
  #
  # Classes store VoolMethods, while Types store CallableMethod
  # A Type referes to a Class , but a Class (interface) is implemented by many types
  # as it changes during the course of it's life. Types do not change. Objects have
  # type, and so only indirectly a class.
  #
  class VoolMethod < Object

    attr_reader :name , :args_type , :frame_type , :source

    def initialize(name , args_type , frame_type , source )
      @name , @args_type , @frame_type , @source = name , args_type, frame_type , source
      raise "Name must be symbol" unless name.is_a?(Symbol)
      raise "args_type must be type" unless args_type.is_a?(Parfait::Type)
      raise "frame_type must be type" unless frame_type.is_a?(Parfait::Type)
      raise "source must be vool" unless source.is_a?(Vool::Statement)
      raise "Empty bod" if(source.is_a?(Vool::Statements) and source.empty?)
    end

    def create_callable_method( type )
      raise "create_method #{type.inspect} is not a Type" unless type.is_a? Parfait::Type
      type.create_method( @name , @args_type , @frame_type)
    end

    def compiler_for(self_type)
      callable_method = create_callable_method(self_type)
      compiler = Risc::MethodCompiler.new( callable_method )
      head = source.to_mom( compiler )
      compiler.add_mom(head)
      compiler
    end
  end
end
