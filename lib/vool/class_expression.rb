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
  class ClassExpression < Expression
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name , @super_class_name = name , supe
      case body
      when MethodExpression
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
        when MethodExpression
          node.to_mom(@clazz)
        when ClassMethodExpression
          node.to_mom(@clazz.singleton_class)
        else
          raise "Only methods for now #{node.class}:#{node}"
        end
      end
      Mom::MomCollection.new(method_compilers)
    end

    # This creates the Parfait class. But doesn not handle reopening yet, so only new classes
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
      end
      create_types
      @clazz
    end

    # goes through the code looking for instance variables (and their assignments)
    # adding each to the respective type, ie class or singleton_class, depending
    # on if they are instance or class instance variables.
    #
    # Class variables are deemed a design mistake, ie not implemented (yet)
    def create_types
      self.body.statements.each do |node|
        case node
        when MethodExpression
          target = @clazz
        when ClassMethodExpression
          target = @clazz.singleton_class
        else
          raise "Only methods for now #{node.class}:#{node}"
        end
        node.each do |exp|
          case exp
          when InstanceVariable, IvarAssignment
            target.add_instance_variable( exp.name , :Object  )
          when ClassVariable #, ClassVarAssignment
            raise "Class variables not implemented #{node.name}"
          end
        end
      end
    end
    def to_s(depth = 0)
      derive = super_class_name ? "< #{super_class_name}" : ""
      at_depth(depth , "class #{name} #{derive}\n#{@body.to_s(depth + 1)}\nend")
    end
  end
end
