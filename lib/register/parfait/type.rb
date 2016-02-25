# An Object is really a hash like structure. It is dynamic and
# you want to store values by name (instance variable names).
#
# One could (like mri), store the names in each object, but that is wasteful
# Instead we store only the values, and access them by index.
# The Layout allows the mapping of names to index.

# The Layout of an object describes the memory type of the object
# The Layout is a simple list of the names of instance variables.
#
# As every object has a Layout to describe it, the name "type" is the
# first name in the list for every Layout.

# But as we want every Object to have a class, the Layout carries that class.
# So the type of type has an entry "object_class"

# But Objects must also be able to carry methods themselves (ruby calls singleton_methods)
# and those too are stored in the Layout (both type and class include behaviour)

# In other words, the Layout is a list of names that describe
# the values stored in an actual object.
# The object is an List of values of length n and
# the Layout is an List of names of length n , plus class reference and methods reference
# Together they turn the object into a hash like structure

module Parfait
  class Type < Object
    attribute :object_class
    include Behaviour

    include Indexed
    self.offset(3)

    def initialize( object_class )
      super()
      add_instance_variable :type ,:Type
      self.object_class = object_class
    end

    def == other
      self.object_id == other.object_id
    end

    # add the name of an instance variable
    # The index will be returned and can subsequently be searched with index_of
    # The index of the name is the index of the data in the object
    #
    # TODO , later we would need to COPY the type to keep the old constant
    #        but now we are concerned with booting, ie getting a working structure
    def add_instance_variable name , type
      raise "Name shouldn't be nil" unless name
      raise "Value Type shouldn't be nil" unless type
      self.push(name)
      self.push(type)
      self.get_length
    end

    def instance_names
      names = List.new
      name = true
      each do |item|
        names.push(item) if name
        name = ! name
      end
      names
    end

    def instance_length
      (self.get_length / 2).to_i # to_i for opal
    end

    alias :super_index :index_of
    def index_of(name)
      raise "Use variable_index instead"
    end

    # index of the variable when using get_internal_word
    # (get_internal_word is 1 based and 1 is always the type)
    def variable_index name
      has = super_index(name)
      return nil unless has
      raise "internal error #{name}:#{has}" if has < 1
      (1 + has / 2).to_i # to_i for opal
    end

    def type_at index
      type_index = index * 2
      get(type_index)
    end

    def inspect
      "Type[#{super}]"
    end

    def sof_reference_name
      "#{self.object_class.name}_Type"
    end
    alias :name :sof_reference_name

    def super_class_name
      nil  # stop resolve recursing up metaclasses
    end

  end
end
