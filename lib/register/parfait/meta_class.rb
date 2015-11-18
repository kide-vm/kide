module Parfait

  # class that acts like a class, but is really the object

  # described in the ruby language book as the eigenclass, what you get with
  # class MyClass
  #     class << self        <--- this is called the eigenclass, or metaclass, and really is just
  #     ....                              the class object but gives us the ability to use the
  #                                       syntax as if it were a class

  # While the "real" metaclass is the layout, we need to honor the constancy of the layout
  # So the layout needs to be copied and replaced anytime it is edited.
  # And then changed in the original object, and thus we need this level of indirection

  # Basically we implement the Behaviour protocol, by forwarding to the layout

  class MetaClass < Object
    include Logging

    attribute :object

    def initialize(object)
      super()
      self.object = object
    end

    def name
      self.object.get_layout.name
    end
    # first part of the protocol is read, just forward to self.object.layout
    def methods
      self.object.get_layout.methods
    end
    def method_names
      self.object.get_layout.method_names
    end
    def get_instance_method fname
      self.object.get_layout.get_instance_method fname
    end
    def resolve_method m_name
      self.object.get_layout.resolve_method m_name
    end

    # the modifying part creates a new layout
    # forwards the action and replaces the layout
    def add_instance_method method
      layout = self.object.get_layout.dup
      ret = layout.add_instance_method(method)
      self.object.set_layout layout
      ret
    end

    def remove_instance_method method_name
      layout = self.object.get_layout.dup
      ret = layout.remove_instance_method(method_name)
      self.object.set_layout layout
      ret
    end

    def create_instance_method  method_name , arguments
      raise "create_instance_method #{method_name}.#{method_name.class}" unless method_name.is_a?(Symbol)
      log.debug "Add_method: #{method_name} clazz: #{self.name}"
      add_instance_method Method.new( self , method_name , arguments )
    end


  end
end
