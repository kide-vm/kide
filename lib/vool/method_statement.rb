module Vool
  class MethodStatement < Statement
    attr_reader :name, :args , :body , :clazz

    def initialize( name , args , body , clazz = nil)
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    def to_mom(clazz)
      @clazz = clazz || raise( "no class in #{self}")
      method = @clazz.add_method_for(name , make_arg_type , make_frame , body )
      compiler = method.compiler_for(clazz.instance_type)
      each do |node| ## TODO: must account for nested blocks (someday)
        node.to_mom(compiler) if node.is_a?(BlockStatement)
      end
      compiler
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def normalize
      MethodStatement.new( @name , @args , @body.normalize)
    end

    def has_yield?
      each{|statement| return true if statement.is_a?(YieldStatement)}
      return false
    end

    def make_arg_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg] = :Object }
      type_hash[:implicit_block] = :Object if has_yield?
      Parfait::NamedList.type_for( type_hash )
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def #{name}(#{arg_str})" , @body.to_s(depth + 1) , "end")
    end

    private

    def make_frame
      type_hash = {}
      @body.each do |node|
        next unless node.is_a?(LocalVariable) or node.is_a?(LocalAssignment)
        type_hash[node.name] = :Object
      end
      Parfait::NamedList.type_for( type_hash )
    end

  end
end
