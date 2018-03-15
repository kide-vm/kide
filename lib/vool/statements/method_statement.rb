module Vool
  class MethodStatement < Statement
    attr_reader :name, :args , :body , :clazz

    def initialize( name , args , body , clazz = nil)
      @name , @args , @body = name , args , body
      raise "no bod" unless body
      @clazz = clazz
    end

    # compile to mom instructions. methods themselves do no result in instructions (yet)
    # instead the resulting instruction tree is saved into the method object that
    #  represents the method
    def to_mom( _ )
      method = @clazz.get_method( @name )
      @body.to_mom(method)
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def normalize
      MethodStatement.new( @name , @args , @body.normalize)
    end

    def create_objects(clazz)
      @clazz = clazz
      raise "no class" unless clazz
      args_type = make_type
      frame_type = make_frame
      method = Parfait::VoolMethod.new(name , args_type , frame_type , body )
      @clazz.add_method( method )
      typed_method = method.create_parfait_method(clazz.instance_type)
      compiler = Risc::MethodCompiler.new( typed_method ).init_method
      head = @body.to_mom( method )
      compiler.add_mom(head)
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
