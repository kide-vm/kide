module Parfait
  # Behaviour is the old smalltalk name for the duperclass of class and singleton_class
  #
  # Classes and singleton_classes are in fact very similar, in that they manage
  # - the type of instances
  # - the methods for instances
  #
  # The main way they differ is that Classes manage type for a class of objects (ie many)
  # whereas singleton_class, or singleton_class manages the type of only one object (here a class)
  #
  # Singleton classes can manage the type/methods of any single object, and in the
  # future off course they will, just not yet. Most single objects don't need that,
  # only Classes and Modules _always _ do, so that's where we start.
  #
  class Behaviour < Object

    attr_reader :instance_type , :instance_methods

    def initialize(type)
      super()
      @instance_methods = List.new
      @instance_type = type
    end

    def methods
      @instance_methods
    end

    def method_names
      names = List.new
      methods.each do |method|
        names.push method.name
      end
      names
    end

    def add_instance_method_for(name , type , frame , body )
      method = Parfait::VoolMethod.new(name , type , frame , body )
      add_instance_method( method )
    end

    def add_instance_method( method )
      raise "not implemented #{method.class} #{method.inspect}" unless method.is_a? VoolMethod
      @instance_methods.push(method)
      method
    end

    def remove_instance_method( method_name )
      found = get_instance_method( method_name )
      found ? methods.delete(found) : false
    end

    def get_instance_method( fname )
      raise "get_instance_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      @instance_methods.find {|m| m.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method( m_name )
      raise "resolve_method #{m_name}.#{m_name.class}" unless m_name.is_a?(Symbol)
      method = get_instance_method(m_name)
      return method if method
      if( s_class = super_class )
        method = s_class.resolve_method(m_name)
      end
      method
    end

    # assume resolving is needed, ie getting has failed, raise if it hasnt
    def resolve_method!( m_name )
      method = get_instance_method(m_name)
      if method
        tm = @instance_type.method_names
        raise "resolve_method #{name}.#{m_name} has #{tm}"
      end
      return nil unless( s_class = super_class )
      s_class.resolve_method(m_name)
    end

    # adding an instance changes the instance_type to include that variable
    def add_instance_variable( name , type)
      @instance_type = @instance_type.add_instance_variable( name , type )
    end

  end
end
