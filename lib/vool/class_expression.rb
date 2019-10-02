module Vool
  # This represents a class at the vool level. Vool is a syntax tree,
  # so here the only child (or children) is a body.
  # Body may either be a MethodStatement, or Statements (either empty or
  # containing MethodStatement)
  #
  # We store the class name and the parfait class
  #
  # The Parfait class gets created by to_parfait, ie only after that is the clazz
  # attribute set.
  #
  class ClassExpression < Expression
    attr_reader :name, :super_class_name , :body
    attr_reader :clazz

    def initialize( name , supe , body)
      @name = name
      @super_class_name = supe || :Object
      raise "what body #{body}" unless body.is_a?(Statements)
      @body = body
    end

    # This creates the Parfait class.
    # Creating the class involves creating the instance_type (or an initial version)
    # which means knowing all used names. So we go through the code looking for
    # InstanceVariables or InstanceVariable Assignments, to do that.
    def to_parfait
      @clazz = Parfait.object_space.get_class_by_name(@name )
      if(@clazz)
        if( @super_class_name != clazz.super_class_name)
          raise "Superclass mismatch for #{@name} , was #{clazz.super_class_name}, now: #{super_class_name}"
        end
      else
        @clazz = Parfait.object_space.create_class(@name , @super_class_name )
      end
      create_types
      @body.statements.each {|meth| meth.to_parfait(@clazz)}
      @clazz
    end

    # We transforms every method (class and object)
    # Other statements are not yet allowed (baring in mind that attribute
    # accessors are transformed to methods in the ruby layer )
    #
    # As there is no class equivalnet in code, a MomCollection is returned,
    # which is just a list of Mom::MethodCompilers
    # The compilers help to transform the code further, into Risc next
    def to_mom( _ )
      method_compilers =  body.statements.collect do |node|
        case node
        when MethodExpression
          node.to_mom(@clazz)
        when ClassMethodExpression
          node.to_mom(@clazz.single_class)
        else
          raise "Only methods for now #{node.class}:#{node}"
        end
      end
      Mom::MomCollection.new(method_compilers)
    end

    # goes through the code looking for instance variables and their assignments.
    # Adding each to the respective type, ie class or singleton_class, depending
    # on if they are instance or class instance variables.
    #
    # Class variables are deemed a design mistake, ie not implemented (yet)
    def create_types
      self.body.statements.each do |node|
        case node
        when MethodExpression
          target = @clazz
        when ClassMethodExpression
          target = @clazz.single_class
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
