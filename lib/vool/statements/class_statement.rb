module Vool
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name , @super_class_name , @body = name , supe , body
    end

    def normalize
      ClassStatement.new(@name , @super_class_name, @body&.normalize )
    end

    # there is no mom equivalent for a class, this should never be called
    def to_mom( _ )
      raise "should not be called (call create_objects)"
    end

    def each(&block)
      block.call(self)
      @body.each(&block) if @body
    end

    def create_objects
      create_class_object
      mom = nil #return mom for test purpose
      self.each {|node| mom = node.create_objects(@clazz) if node.is_a?(MethodStatement)  }
      mom
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
