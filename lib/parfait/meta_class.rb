module Parfait

  # class that acts like a class, but is really the object
  # actually we don't store methods in objects (as ruby with singleton_method) but rather
  #   in the (possibly unique) layout.

  # described in the ruby language book as the eigenclass, what you get with
  # class MyClass
  #     class << self        <--- this is called the eigenclass, or metaclass, and really is just
  #     ....                              the class object but gives us the ability to use the
  #                                       syntax as if it were a class
  #

  class MetaClass < Object
    attribute :me

    def initialize(object)
      super()
      self.me = object
    end

    def super_class
      Space.object_space.get_class_by_name(self.me.super_class_name).meta
    end

    def name
      "Meta#{me.name}".to_sym
    end

  end
end
