module Vool
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name , @super_class_name , @body = name , supe , body
      @body = ScopeStatement.new([]) unless body
    end

    def normalize
      ClassStatement.new(@name , @super_class_name, @body.normalize )
    end
    # compilation to the next layer, mom
    # context coming in for class is nil, also for methods, henceafter a method is passed down
    def to_mom( _ )
      methods = @body.statements.collect { |meth|  meth.to_mom( nil ) }
      Mom::Statements.new(methods)
    end

    def each()
      @body.collect(arr)
      super
    end

    def create_objects
      create_class_object
      body.collect([]).each {|node| node.set_class(@clazz)  }
      body.create_objects
    end

    def create_class_object
      @clazz = Parfait.object_space.get_class_by_name(@name )
      if(@clazz)
        #FIXME super class check with "sup"
        #existing class, don't overwrite type (parfait only?)
      else
        @clazz = Parfait.object_space.create_class(@name , @super_class_name )
        vars = []
        @body.collect([]).each { |node| node.add_ivar(vars) }
        ivar_hash = {}
        vars.each { |var| ivar_hash[var] = :Object }
        @clazz.set_instance_type( Parfait::Type.for_hash( @clazz ,  ivar_hash ) )
      end
    end
  end
end
