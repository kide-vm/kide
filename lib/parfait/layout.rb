# An Object is really a hash like structure. It is dynamic and
# you want to store values by name.
# One could (like mri), store the names in each object, but that is wasteful
# Instead we store only the values, and access them by index.
# The Layout allows the mapping of names to index.

# The Layout of an object describes the memory layout of the object
# The Layout is a simple list of the names of instance variables.
#
# As every object has a Layout to describe it, the name "layout" is the
# first name in the list for every Layout.
# But as we want every Object to have a class, this is the second
# entry in the list. The name for the entry is "object_class"

# In other words, the Layout is a list of names that describe
# the values stored in an actual object.
# The object is an List of values of length n and
# the Layout is an List of names of length n
# Together they turn the object into a hash like structure

module Parfait
  class Layout < Object

    # given a name as symbol, return the integer index of that entry
    # we use 0 as "not found" as we don't want negatives, and can't raise
    # luckily 0 is always the type-word in an object and so by returning
    # one-offsets we can use the return value straight without adding 1
    def index_of( name )
      #internal implementation....
    end

  end
end
