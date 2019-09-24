module Vool
  class MethodExpression < Expression
    attr_reader :name, :args , :body

    def initialize( name , args , body )
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
      raise "Not Vool #{@body}" unless @body.is_a?(Statement)
    end

    # create the parfait VoolMethod to hold the code for this method
    #
    # Must pass in the actual Parfait class (default nil is just to conform to api)
    def to_parfait( clazz = nil )
      raise "No class given to method #{name}" unless clazz
      clazz.add_instance_method_for(name , make_arg_type , make_frame , body )
    end

    # Creates the Mom::MethodCompiler that will do the next step
    def to_mom(clazz)
      raise( "no class in #{self}") unless clazz
      method = clazz.get_instance_method(@name)
      raise( "no method in #{@name} in #{clazz.name}") unless method
      compiler = method.compiler_for(clazz.instance_type)
      compiler
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def has_yield?
      each{|statement| return true if statement.is_a?(YieldStatement)}
      return false
    end

    def make_arg_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg] = :Object }
      type_hash[:implicit_block] = :Block if has_yield?
      Parfait::Type.for_hash( type_hash )
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def #{name}(#{arg_str})\n#{@body.to_s(depth + 1)}\nend")
    end

    private

    def make_frame
      nodes = []
      @body.each { |node| nodes << node }
      nodes.dup.each do |node|
        next unless node.is_a?(LambdaExpression)
        node.each {|block_scope| nodes.delete(block_scope)}
      end
      type_hash = {}
      nodes.each do |node|
        next unless node.is_a?(LocalVariable) or node.is_a?(LocalAssignment)
        type_hash[node.name] = :Object
      end
      Parfait::Type.for_hash( type_hash )
    end

  end
end
