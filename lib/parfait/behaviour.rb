# Behaviour is something that has methods, basically class and modules superclass

# instance_methods is the attribute in the including class that has the methods

module Parfait
  module Behaviour

    def initialize
      super()
      instance_methods = List.new
    end

    def methods
      m = instance_methods
      return m if m
      instance_methods = List.new
    end

    def method_names
      names = List.new
      self.methods.each do |method|
        names.push method.name
      end
      names
    end

    def add_instance_method( method )
      raise "not implemented #{method.class} #{method.inspect}" unless method.is_a? VoolMethod
      method
    end

    def remove_instance_method( method_name )
      found = get_instance_method( method_name )
      found ? self.methods.delete(found) : false
    end

    def get_instance_method( fname )
      raise "get_instance_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      #if we had a hash this would be easier.  Detect or find would help too
      self.instance_methods.find {|m| m.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method( m_name )
      raise "resolve_method #{m_name}.#{m_name.class}" unless m_name.is_a?(Symbol)
      method = get_instance_method(m_name)
      return method if method
      if( super_class_name != :Object )
        method = self.super_class.resolve_method(m_name)
      end
      method
    end

  end
end
