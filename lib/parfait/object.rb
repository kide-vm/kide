# to be precise, this should be an ObjectReference, as the Reference is a Value
# but we don't want to make that distinction all the time , so we don't.

# that does lead to the fact that we have Reference functions on the Object though

# Objects are arranged or layed out (in memory) according to their Layout
# every object has a Layout. Layout objects are immutalbe and may be resued for a group/class
# off objects.
# The Layout of an object may change, but then a new Layout is created
# The Layout also defines the class of the object
# The Layout is **always** the first entry (index 1) in an object, but the type word is index 0

module Parfait
  LAYOUT_INDEX  = 1

  class Object < Value

    def self.new *args
      object = self.allocate
      #HACK, but used to do the adapter in the init, bu that is too late now
      object.fake_init if object.respond_to?(:fake_init) # at compile, not run-time
      # have to grab the class, because we are in the ruby class not the parfait one
      cl = Space.object_space.get_class_by_name( self.name.split("::").last.to_sym)
      # and have to set the layout before we let the object do anything. otherwise boom
      object.set_layout cl.object_layout

      object.send :initialize , *args
      object
    end

    # Objects memory functions. Object memory is 1 based
    # but we implement it with ruby array (0 based) and don't use 0
    # These are the same functions that Builtin implements for run-time
    include Padding
    include Positioned

    def fake_init
      @memory = Array.new(16)
      @position = nil
      self # for chaining
    end

    # 1 -based index
    def get_internal(index)
      @memory[index]
    end
    # 1 -based index
    def set_internal(index , value)
      raise "failed init for #{self.class}" unless @memory
      raise "Word[#{index}] = " if((self.class == Parfait::Word) and value.nil? )
      @memory[index] = value
      value
    end

    def self.attributes names
      names.each{|name| attribute(name) }
    end

    def self.attribute name
      define_method(name) { get_instance_variable(name) }
      define_method("#{name}=".to_sym) { |value| set_instance_variable(name , value) }
    end

    def == other
      self.object_id == other.object_id
    end

    # This is the crux of the object system. The class of an object is stored in the objects
    # memory (as opposed to an integer that has no memory and so always has the same class)
    #
    # In Salama we store the class in the Layout, and so the Layout is the only fixed
    # data that every object carries.
    def get_class()
      l = get_layout()
      #puts "Layout #{l.class} in #{self.class} , #{self}"
      l.object_class()
    end

    # private
    def set_layout(layout)
      # puts "Layout was set for #{self.class}"
      raise "Nil layout" unless layout
      set_internal(LAYOUT_INDEX , layout)
    end

    # so we can keep the raise in get_layout
    def has_layout?
      ! get_internal(LAYOUT_INDEX).nil?
    end

    def get_layout()
      l = get_internal(LAYOUT_INDEX)
      #puts "get layout for #{self.class} returns #{l.class}"
      raise "No layout #{self.object_id.to_s(16)}:#{self.class} " unless l
      return l
    end

    # return the metaclass
    def meta
      MetaClass.new self
    end

    def get_instance_variables
      get_layout().instance_names
    end

    def get_instance_variable name
      index = instance_variable_defined(name)
      #puts "getting #{name} at #{index}"
      return nil if index == nil
      return get_internal(index)
    end

    def set_instance_variable name , value
      index = instance_variable_defined(name)
      return nil if index == nil
      return set_internal(index , value)
    end

    def instance_variable_defined name
      get_layout().variable_index(name)
    end

    def padded_length
      padded_words( get_layout().instance_length )
    end

    # parfait versions are deliberately called different, so we "relay"
    # have to put the "@" on the names for sof to take them off again
    def instance_variables
      get_instance_variables.to_a.collect{ |n| "@#{n}".to_sym }
    end
    # name comes in as a ruby @var name
    def instance_variable_get name
      var = get_instance_variable name.to_s[1 .. -1].to_sym
      #puts "getting #{name}  #{var}"
      var
    end

  end
end
