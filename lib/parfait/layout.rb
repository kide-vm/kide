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
    attribute :object_class

    def initialize( object_class )
      super()
      self.object_class = object_class
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
      self.push(1) if self.get_length == 0
      self.push(name)
      self.get_length
    end

    def object_instance_names
      names = List.new
      index = 3
      while index <= self.get_length
        item = get(index)
        names.push item
        index = index + 1
      end
      names
    end

    alias :list_index :index_of
    # private inheritance is something to think off, we don't really want the list api exported
    def index_of name
      raise "should not rely on layout internal structure, use variable_index"
    end

    # index of a variable name into the layout.
    # layout is a list, so lowest index is 1
    # :layout is a variable for every object, so 1 is taken for :layout
    # still, the index is the same.
    def variable_index name
      list_index(name)
    end

    def inspect
      ret = "Layout["
      index = 3
      while index <= self.get_length
        item = get(index)
        ret += item.inspect
        ret += "," unless index == self.get_length
        index = index + 1
      end
      ret += "]"
      ret
    end

    def sof_reference_name
      "#{self.object_class.name}_Layout"
    end

  end
end
