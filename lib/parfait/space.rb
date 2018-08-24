
# A Space is a collection of pages. It stores objects, the data for the objects,
# not references. See Page for more detail.

# Pages are stored by the object size they represent in a hash.

# Space and Page work together in making *new* objects available.
# "New" is slightly misleading in that normal operation only ever
# recycles objects.

module Parfait
  # Make the object space globally available
  def self.object_space
    @object_space
  end

  # TODO Must get rid of the setter (move the boot process ?)
  def self.set_object_space( space )
    @object_space = space
  end

  # The Space contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main".
  # This _must be supplied by the compled code (similar to c)
  # There is a start and exit block that call main, which receives an List of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  class Space < Object

    attr  :type, :classes , :types , :factories
    attr  :next_message , :next_address
    attr  :messages, :addresses
    attr  :true_object , :false_object , :nil_object

    def initialize( classes )
      self.classes = classes
      self.types = Dictionary.new
      classes.each do |name , cl|
        add_type(cl.instance_type)
      end
      self.factories = Dictionary.new
      factories[ :Integer ] = Factory.new( classes[:Integer].instance_type)
      400.times { self.addresses = ReturnAddress.new(0,self.addresses) }
      message = Message.new(nil)
      50.times do
        self.messages = Message.new( message )
        message.set_caller( self.messages )
        message = self.messages
      end
      self.next_message = self.messages
      self.next_address = self.addresses
      self.true_object = Parfait::TrueClass.new
      self.false_object = Parfait::FalseClass.new
      self.nil_object = Parfait::NilClass.new
    end

    def self.type_length
      12
    end
    def self.memory_size
      16
    end

    # return the factory for the given type
    # or more exactly the type that has a class_name "name"
    def get_factory_for(name)
      factories[name]
    end

    # use the factory of given name to generate next_object
    # just a shortcut basically
    def get_next_for(name)
      factories[name].get_next_object
    end

    # hand out a return address for use as constant the address is added
    def get_address
      addr = next_address
      self.next_address = next_address.next_integer
      addr
    end

    # yield each type in the space
    def each_type
      types.values.each do |type|
        yield(type)
      end
    end

    # add a type, meaning the instance given must be a valid type
    def add_type( type )
      hash = type.hash
      raise "upps #{hash} #{hash.class}" unless hash.is_a?(Fixnum)
      was = types[hash]
      return was if was
      types[hash] = type
    end

    # get a type by the type hash (the hash is what uniquely identifies the type)
    def get_type_for( hash )
      types[hash]
    end

    # all methods form all types
    def get_all_methods
      methods = []
      each_type do | type |
        type.each_method do |meth|
          methods << meth
        end
      end
      methods
    end

    # shortcut to get the main method. main is defined on Space
    def get_main
      space = get_class_by_name :Space
      space.instance_type.get_method :main
    end

    # shortcut to get the __init__ method, which is defined on Object
    def get_init
      object = get_class_by_name :Object
      object.instance_type.get_method :__init__
    end

    # get the current instance_typ of the class with the given name
    def get_type_by_class_name(name)
      clazz = get_class_by_name(name)
      return nil unless clazz
      clazz.instance_type
    end

    # get a class by name (symbol)
    # return nili if no such class. Use bang version if create should be implicit
    def get_class_by_name( name )
      raise "get_class_by_name #{name}.#{name.class}" unless name.is_a?(Symbol)
      c = classes[name]
      #puts "MISS, no class #{name} #{name.class}" unless c # " #{classes}"
      #puts "CLAZZ, #{name} #{c.get_type.get_length}" if c
      c
    end

    # get or create the class by the (symbol) name
    # notice that this method of creating classes implies Object superclass
    def get_class_by_name!(name , super_class = :Object)
      c = get_class_by_name(name)
      return c if c
      create_class( name ,super_class)
    end

    # this is the way to instantiate classes (not Parfait::Class.new)
    # so we get and keep exactly one per name
    def create_class( name , superclass = nil )
      raise "create_class #{name.class}" unless name.is_a? Symbol
      superclass = :Object unless superclass
      raise "create_class #{superclass.class}" unless superclass.is_a? Symbol
      type = get_type_by_class_name(superclass)
      c = Class.new(name , superclass , type )
      classes[name] = c
    end

    def rxf_reference_name
      "space"
    end

  end
  # ObjectSpace
  # :each_object, :garbage_collect, :define_finalizer, :undefine_finalizer, :_id2ref, :count_objects
end
