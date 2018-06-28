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
      method.compile_to_risc(clazz.instance_type)
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
