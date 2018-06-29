module Vool
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name , @super_class_name = name , supe
      case body
      when MethodStatement
        @body = Statements.new([body])
      when Statements
        @body = body
      when nil
        @body = Statements.new([])
      else
        raise "what body #{body}"
      end
    end

    def normalize
      meths = body.statements.collect{|meth| meth.normalize}
      ClassStatement.new(@name , @super_class_name, Statements.new(meths) )
    end

    def to_mom( _ )
      create_class_object
      mom = nil #return mom for test purpose
      self.each do |node|
        mom = node.to_mom(@clazz) if node.is_a?(MethodStatement)
      end
      mom
    end

    def each(&block)
      block.call(self)
      @body.each(&block) if @body
    end

    def create_class_object
      @clazz = Parfait.object_space.get_class_by_name(@name )
      if(@clazz)
        #FIXME super class check with "sup"
        #existing class, don't overwrite type (parfait only?)
      else
        @clazz = Parfait.object_space.create_class(@name , @super_class_name )
        ivar_hash = {}
        self.each do |node|
          next unless node.is_a?(InstanceVariable) or node.is_a?(IvarAssignment)
          ivar_hash[node.name] = :Object
        end
        @clazz.set_instance_type( Parfait::Type.for_hash( @clazz ,  ivar_hash ) )
      end
    end
  end
end
