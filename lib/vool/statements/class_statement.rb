module Vool
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name , @super_class_name , @body = name , supe , body
    end

    def normalize
      ClassStatement.new(@name , @super_class_name, @body.normalize )
    end

    # compilation to the next layer, mom
    # context coming in for class is nil, also for methods, henceafter a method is passed down
    def to_mom( _ )
      @body.to_mom()
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def create_objects
      create_class_object
      self.each {|node| node.create_objects(@clazz) if node.is_a?(MethodStatement)  }
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
