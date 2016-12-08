# An Object is really a hash like structure. It is dynamic and
# you want to store values by name (instance variable names).
#
# One could (like mri), store the names in each object, but that is wasteful in both time and space.
# Instead we store only the values, and access them by index.
# The Type allows the mapping of names to index.

# The Type of an object describes the memory layout of the object. In a c analogy, it is the
# information defined in a struct.
# The Type is a list of the names of instance variables, and their value types (int etc).
#
# Every object has a Type to describe it, so it's *first* instance variable is **always**
# "type". This means the name "type" is the first name in the list
# for every Type instance.

# But, as we want every Object to have a class, the Type carries that class.
# So the type of type has an entry "object_class"

# But Objects must also be able to carry methods themselves (ruby calls singleton_methods)
# and those too are stored in the Type (both type and class include behaviour)

# The object is an List of values of length n

# The Type is a list of n names and n types that describe the values stored in an actual object.

# Together they turn the object into a hash like structure

# For types to be a useful concept, they have to be unique and immutable. Any "change", like adding
# a name/type pair, will result in a new instance.

# The Type class carries a hash of types of the systems, which is used to ensure that
# there is only one instance of every type. Hash and equality are defined on type
# for this to work.

module Parfait
  class Type < Object
    attribute :object_class
    include Behaviour

    include Indexed
    self.offset(3)

    def self.new_for_hash( object_class , hash)
      new_type = Type.new( object_class , hash)
      code = new_type.hash
      Space.object_space.types[code] = new_type
      new_type
    end

    def self.hash_code_for( dict )
      index = 1
      hash = 0
      dict.each do |name , type|
        item_hash = name.hash + type.hash
        hash  += item_hash + (item_hash / 256 ) * index
        index += 1
      end
      hash
    end

    def initialize( object_class , hash = nil)
      super()
      private_add_instance_variable :type ,:Type
      self.object_class = object_class
      hash.each do |name , type|
        private_add_instance_variable name , type
      end if hash
    end

    def == other
      self.object_id == other.object_id
    end

    # add the name of an instance variable
    # Type objects are immutable, so a new object is returned
    # As types are also unique, two same adds will result in identical results
    def add_instance_variable( name , type )
      hash = to_hash
      hash[name] = type
      code = Type.hash_code_for( hash )
      existing = Space.object_space.types[code]
      if existing
        return existing
      else
        return Type.new_for_hash( object_class , hash)
      end
    end

    def instance_names
      names = List.new
      each_pair do |name , type|
        names.push(name)
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

    def to_hash
      hash = Dictionary.new
      each_pair do |name, type |
        hash[name] = type
      end
      hash
    end

    def hash
      Type.hash_code_for( to_hash )
    end

    private

    def private_add_instance_variable( name , type)
      raise "Name shouldn't be nil" unless name
      raise "Value Type shouldn't be nil" unless type
      self.push(name)
      self.push(type)
    end

  end
end
