module Vool
  class MethodStatement < Statement
    attr_reader :name, :args , :body , :clazz

    def initialize( name , args , body , clazz = nil)
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    def to_mom(clazz)
      @clazz = clazz
      raise "no class" unless clazz
      method = Parfait::VoolMethod.new(name , make_type , make_frame , body )
      @clazz.add_method( method )
      typed_method = method.create_typed_method(clazz.instance_type)
      head = @body.to_mom( typed_method )
      compiler = Risc::MethodCompiler.new( typed_method )
      compiler.add_mom(head)
      head # return for testing
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def normalize
      MethodStatement.new( @name , @args , @body.normalize)
    end

    private

    def make_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg] = :Object }
      Parfait::NamedList.type_for( type_hash )
    end

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
