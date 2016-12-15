# Behaviour is something that has methods, basically class and modules superclass

# instance_methods is the attribute in the including class that has the methods

module Parfait
  module Behaviour
    # when included we set up the instance_methods attribute
    def self.included(base)
      base.attribute :instance_methods
    end

    def initialize
      super()
      self.instance_methods = List.new
    end

    def methods
      m = self.instance_methods
      return m if m
      self.instance_methods = List.new
    end

    def method_names
      names = List.new
      self.methods.each do |method|
        names.push method.name
      end
      names
    end

    def add_instance_method( method )
      raise "not implemented #{method.class} #{method.inspect}" unless method.is_a? RubyMethod
      method
    end

    def remove_instance_method( method_name )
      found = get_instance_method( method_name )
      found ? self.methods.delete(found) : false
    end

    def get_instance_method( fname )
      raise "get_instance_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      #if we had a hash this would be easier.  Detect or find would help too
      self.methods.find {|m| m.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method m_name
      raise "resolve_method #{m_name}.#{m_name.class}" unless m_name.is_a?(Symbol)
      method = get_instance_method(m_name)
      return method if method
      if( self.super_class_name )
        method = self.super_class.resolve_method(m_name)
      end
      method
    end

  end
end
