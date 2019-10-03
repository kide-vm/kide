module Vool
  class ClassMethodExpression < Expression
    attr_reader :name, :args , :body

    def initialize( name , args , body )
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
    end

    # create the parfait VoolMethod to hold the code for this method
    #
    # Must pass in the actual Parfait class (default nil is just to conform to api)
    def to_parfait( clazz = nil )
      raise "No class given to class method #{name}" unless clazz
      vool_m = clazz.single_class.create_instance_method_for(name , make_arg_type , make_frame , body )
      vool_m.create_callable_method_for(clazz.single_class.instance_type)
      vool_m
    end

    def to_slot(clazz)
      raise "not singleton #{clazz.class}" unless clazz.class == Parfait::SingletonClass
      raise( "no class in #{self}") unless clazz
      method = clazz.get_instance_method(name )
      raise( "no class method in #{@name} in #{clazz}") unless method
      #puts "CLass method Class:#{clazz}:#{name}"
      compiler = method.compiler_for(clazz.instance_type)
      each {|node| raise "Blocks not implemented" if node.is_a?(LambdaExpression)}
      compiler
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def make_arg_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg] = :Object }
      Parfait::Type.for_hash( type_hash )
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def self.#{name}(#{arg_str})\n#{@body.to_s(1)}\nend")
    end

    private

    def make_frame
      nodes = []
      @body.each { |node| nodes << node }
      type_hash = {}
      nodes.each do |node|
        next unless node.is_a?(LocalVariable) or node.is_a?(LocalAssignment)
        type_hash[node.name] = :Object
      end
      Parfait::Type.for_hash( type_hash )
    end

  end
end
