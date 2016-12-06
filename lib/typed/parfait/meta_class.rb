module Parfait

  # class that acts like a class, but is really the object

  # described in the ruby language book as the eigenclass, what you get with
  # class MyClass
  #     class << self        <--- this is called the eigenclass, or metaclass, and really is just
  #     ....                              the class object but gives us the ability to use the
  #                                       syntax as if it were a class

  # While the "real" metaclass is the type, we need to honor the constancy of the type
  # So the type needs to be copied and replaced anytime it is edited.
  # And then changed in the original object, and thus we need this level of indirection

  # Basically we implement the Behaviour protocol, by forwarding to the type

  class MetaClass < Object
    include Logging

    attribute :object

    def initialize(object)
      super()
      self.object = object
    end

    def name
      self.object.get_type.name
    end
    # first part of the protocol is read, just forward to self.object.type
    def methods
      self.object.get_type.methods
    end
    def method_names
      self.object.get_type.method_names
    end
    def get_instance_method fname
      self.object.get_type.get_instance_method fname
    end
    def resolve_method m_name
      self.object.get_type.resolve_method m_name
    end

    # the modifying part creates a new type
    # forwards the action and replaces the type
    def add_instance_method method
      type = self.object.get_type.dup
      ret = type.add_instance_method(method)
      self.object.set_type type
      ret
    end

    def remove_instance_method method_name
      type = self.object.get_type.dup
      ret = type.remove_instance_method(method_name)
      self.object.set_type type
      ret
    end

    def create_instance_method  method_name , arguments
      raise "create_instance_method #{method_name}.#{method_name.class}" unless method_name.is_a?(Symbol)
      log.debug "Add_method: #{method_name} clazz: #{self.name}"
      add_instance_method Method.new( self , method_name , arguments )
    end


  end
end
