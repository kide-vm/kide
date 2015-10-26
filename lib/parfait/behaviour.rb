
# described in the ruby language book as the eigenclass, what you get with
# class MyClass
#     class << self        <--- this is called the eigenclass, or metaclass, and really is just
#     ....                              the class object but gives us the ability to use the
#                                       syntax as if it were a class
#

module Parfait
  module Behaviour
    def self.included(base)
      base.attribute :instance_methods
    end

    def method_names
      names = List.new
      self.instance_methods.each do |method|
        names.push method.name
      end
      names
    end

    def add_instance_method method
      raise "not a method #{method.class} #{method.inspect}" unless method.is_a? Method
      raise "syserr #{method.name.class}" unless method.name.is_a? Symbol
      raise "Adding to wrong class, should be #{method.for_class}" if method.for_class != self
      found = get_instance_method( method.name )
      if found
        self.instance_methods.delete(found)
      end
      self.instance_methods.push method
      #puts "#{self.name} add #{method.name}"
      method
    end

    def remove_instance_method method_name
      found = get_instance_method( method_name )
      if found
        self.instance_methods.delete(found)
      else
        raise "No such method #{method_name} in #{self.name}"
      end
      return true
    end

    def get_instance_method fname
      raise "get_instance_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      #if we had a hash this would be easier.  Detect or find would help too
      self.instance_methods.each do |m|
        return m if(m.name == fname )
      end
      nil
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method m_name
      raise "resolve_method #{m_name}.#{m_name.class}" unless m_name.is_a?(Symbol)
      method = get_instance_method(m_name)
      return method if method
      if( self.super_class_name )
        method = self.super_class.resolve_method(m_name)
        raise "Method not found #{m_name}, for \n#{self}" unless method
      end
      method
    end

  end
end
