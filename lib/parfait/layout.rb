# An Object is really a hash like structure. It is dynamic and
# you want to store values by name (instance variable names).
#
# One could (like mri), store the names in each object, but that is wasteful
# Instead we store only the values, and access them by index.
# The Layout allows the mapping of names to index.

# The Layout of an object describes the memory layout of the object
# The Layout is a simple list of the names of instance variables.
#
# As every object has a Layout to describe it, the name "layout" is the
# first name in the list for every Layout.

# But as we want every Object to have a class, the Layout carries that class.
# So the layout of layout has an entry "object_class"

# In other words, the Layout is a list of names that describe
# the values stored in an actual object.
# The object is an List of values of length n and
# the Layout is an List of names of length n
# Together they turn the object into a hash like structure

module Parfait
  class Layout < List

    def initialize( object_class )
      super()
      @object_class = object_class
    end

    def == other
      self.object_id == other.object_id
    end

    # add the name of an instance variable
    # The index will be returned and can subsequently be searched with index_of
    # The index of the name is the index of the data in the object
    #
    # TODO , later we would need to COPY the layout to keep the old constant
    #        but now we are concerned with booting, ie getting a working structure
    def add_instance_variable name
      self.push(name)
      self.get_length
    end

    # beat the recursion! fixed known offset for class object in the layout
    def get_object_class()
      return @object_class
    end

    def sof_reference_name
      "#{@object_class.name}_Layout"
    end

  end
end
