module Vool
  # This represents a class at the vool level. Vool is a syntax tree,
  # so here the only child (or children) is a body.
  # Body may either be a MethodStatement, or Statements (either empty or
  # containing MethodStatement)
  #
  # We store the class name and the parfait class
  #
  # The Parfait class gets created lazily on the way down to mom, ie the clazz
  # attribute will only be set after to_mom, or a direct call to create_class
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

    # This create the Parfait class, and then transforms every method
    #
    # As there is no class equivalnet in code, a MomCollection is returned,
    # which is just a list of Mom::MethodCompilers
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

    # This creates the Parfait class. But doesn not hadle reopening yet, so only new classes
    # Creating the class involves creating the instance_type (or an initial version)
    # which means knowing all used names. So we go through the code looking for
    # InstanceVariables or InstanceVariable Assignments, to do that.
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
        @clazz
      end
    end

    def to_s(depth = 0)
      at_depth(depth , "class #{name}" , @body.to_s(depth + 1) , "end")
    end
  end
end
