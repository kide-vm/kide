module Vool
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name , @super_class_name , @body = name , supe , (body || [])
    end

    def collect(arr)
      @body.collect(arr)
      super
    end

    def create_objects
      @clazz = Parfait.object_space.get_class_by_name(@name )
      if(@clazz)
        #FIXME super class check with "sup"
      else #existing class, don't overwrite type (parfait only?)
        @clazz = Parfait.object_space.create_class(@name , @super_class_name )
#FIXME
#        ivar_hash = Passes::TypeCollector.new.collect(body)
#        @clazz.set_instance_type( Parfait::Type.for_hash( clazz ,  ivar_hash ) )
      end
      body.create_objects
#      methods = create_methods(clazz , body)
#      compile_methods(clazz,methods)
    end

  end
end
