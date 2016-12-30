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
    def self.attributes
      [:names , :types , :object_class , :methods ]
    end
    attr_reader :object_class , :names , :types , :methods

    def self.for_hash( object_class , hash)
      hash[:type] = :Type unless hash[:type]
      new_type = Type.new( object_class , hash)
      code = hash_code_for_hash( hash )
      Parfait.object_space.types[code] = new_type
      new_type
    end

    def self.hash_code_for_hash( dict )
      index = 1
      hash_code = 5467
      dict.each do |name , type|
        next if name == :type
        item_hash = str_hash(name) + str_hash(type)
        hash_code  += item_hash + (item_hash / 256 ) * index
        index += 1
      end
      hash_code
    end

    def self.str_hash(str)
      if RUBY_ENGINE == 'opal'
        hash = 5381
        str.to_s.each_char do |c|
          hash = ((hash << 5) + hash) + c.to_i; # hash * 33 + c  without getting bignums
        end
        hash % (2 ** 51)
      else
        str.hash
      end
    end

    def initialize( object_class , hash )
      super()
      set_object_class( object_class)
      init_lists( hash )
    end

    # this part of the init is seperate because at boot time we can not use normal new
    # new is overloaded to grab the type from space, and before boot, that is not set up
    def init_lists(hash)
      @methods = List.new
      @names = List.new
      @types = List.new
      raise "No type Type in #{hash}" unless hash[:type]
      private_add_instance_variable(:type , hash[:type]) #first
      hash.each do |name , type|
        private_add_instance_variable(name , type) unless name == :type
      end
    end

    def to_s
      "#{@object_class.name}-#{@names.inspect}"
    end

    def method_names
      names = List.new
      @methods.each do |method|
        names.push method.name
      end
      names
    end

    def create_method( method_name , arguments )
      raise "create_method #{method_name}.#{method_name.class}" unless method_name.is_a?(Symbol)
      #puts "Self: #{self.class} clazz: #{clazz.name}"
      type = arguments
      type = Parfait::Type.for_hash( @object_class , arguments) if arguments.is_a?(Hash)
      add_method TypedMethod.new( self , method_name , type )
    end

    def add_method( method )
      raise "not a method #{method.class} #{method.inspect}" unless method.is_a? TypedMethod
      raise "syserr #{method.name.class}" unless method.name.is_a? Symbol
      if self.is_a?(Class) and (method.for_type != self)
        raise "Adding to wrong class, should be #{method.for_class}"
      end
      found = get_method( method.name )
      if found
        @methods.delete(found)
      end
      @methods.push method
      #puts "#{self.name} add #{method.name}"
      method
    end

    def remove_method( method_name )
      found = get_method( method_name )
      raise "No such method #{method_name} in #{self.name}" unless found
      @methods.delete(found)
    end

    def get_method( fname )
      raise "get_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      #if we had a hash this would be easier.  Detect or find would help too
      @methods.each do |m|
        return m if(m.name == fname )
      end
      nil
    end

    def == other
      self.object_id == other.object_id
    end

    # add the name of an instance variable
    # Type objects are immutable, so a new object is returned
    # As types are also unique, two same adds will result in identical results
    def add_instance_variable( name , type )
      raise "No nil name" unless name
      raise "No nil type" unless type
      hash = to_hash
      hash[name] = type
      code = Type.hash_code_for_hash( hash )
      existing = Parfait.object_space.types[code]
      return existing if existing
      return Type.for_hash( @object_class , hash)
    end

    def set_object_class(oc)
      raise "object class should be a class, not #{oc.class}" unless oc.is_a?(Class)
      @object_class = oc
    end

    def instance_length
      @names.get_length()
    end

    # index of the variable when using get_internal_word
    # (get_internal_word is 1 based and 1 is always the type)
    def variable_index( name )
      has = names.index_of(name)
      return nil unless has
      raise "internal error #{name}:#{has}" if has < 1
      has
    end

    def get_length()
      @names.get_length()
    end

    def name_at( index )
      @names.get(index)
    end

    def type_at( index )
      @types.get(index)
    end

    def inspect
      "Type[#{names.inspect}]"
    end

    def sof_reference_name
      "#{@object_class.name}_Type"
    end
    alias :name :sof_reference_name

    def to_hash
      hash = Dictionary.new
      @names.each_with_index do |name, index |
        hash[name] = @types[index]
      end
      hash
    end

    def hash
      Type.hash_code_for_hash( to_hash )
    end

    private

    def private_add_instance_variable( name , type)
      raise "Name shouldn't be nil" unless name
      raise "Value Type shouldn't be nil" unless type
      @names.push(name)
      @types.push(type)
    end

  end
end
