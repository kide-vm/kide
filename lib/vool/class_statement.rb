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

    def to_mom( _ )
      create_class_object
      method_compilers =  body.statements.collect do |node|
        case node
        when MethodStatement
          node.to_mom(@clazz)
        when ClassMethodStatement
          node.to_mom(@clazz.meta_class)
        else
          raise "Only methods for now #{node.class}:#{node}"
        end
      end
      Mom::MomCollection.new(method_compilers)
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
        #TODO this should start from Object Type and add one name at a time.
        # So the "trail" of types leading to this one exists.
        # Also the Class always has a valid type.
        ivar_hash = {}
        self.each do |node|
          next unless node.is_a?(InstanceVariable) or node.is_a?(IvarAssignment)
          ivar_hash[node.name] = :Object
        end
        @clazz.set_instance_type( Parfait::Type.for_hash( @clazz ,  ivar_hash ) )
      end
    end

    def to_s(depth = 0)
      at_depth(depth , "class #{name}" , @body.to_s(depth + 1) , "end")
    end
  end
end
