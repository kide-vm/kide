
# A Space is a collection of pages. It stores objects, the data for the objects,
# not references. See Page for more detail.

# Pages are stored by the object size they represent in a hash.

# Space and Page work together in making *new* objects available.
# "New" is slightly misleading in that normal operation only ever
# recycles objects.

module Parfait
  # Make the object space globally available
  def self.object_space
    @@object_space
  end

  # TODO Must get rid of the setter (move the boot process ?)
  def self.set_object_space space
    @@object_space = space
  end

  # The Space contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main".
  # This _must be supplied by the compled code (similar to c)
  # There is a start and exit block that call main, which receives an List of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  class Space < Object

    def initialize(classes )
      @classes = classes
      @types = Dictionary.new
      message = Message.new(nil)
      50.times do
        @first_message = Message.new message
        #puts "INIT caller #{message.object_id} to #{@first_message.object_id}"
        message.set_caller @first_message
        message = @first_message
      end
      @classes.each do |name , cl|
        add_type(cl.instance_type)
      end
    end

    attr_reader  :classes , :first_message

    def each_type
      @types.values.each do |type|
        yield(type)
      end
    end

    def add_type(type)
      hash = type.hash
      raise "upps #{hash} #{hash.class}" unless hash.is_a?(Fixnum)
      was = @types[hash]
      return was if was
      @types[hash] = type
    end

    def get_type_for( hash )
      @types[hash]
    end

    # all methods form all types
    def collect_methods
      methods = []
      each_type do | type |
        type.methods.each do |meth|
          methods << meth
        end
      end
      methods
    end

    def get_main
      kernel = get_class_by_name :Space
      kernel.instance_type.get_method :main
    end

    def get_init
      kernel = get_class_by_name :Kernel
      kernel.instance_type.get_method :__init__
    end

    # get a class by name (symbol)
    # return nili if no such class. Use bang version if create should be implicit
    def get_class_by_name( name )
      raise "get_class_by_name #{name}.#{name.class}" unless name.is_a?(Symbol)
      c = @classes[name]
      #puts "MISS, no class #{name} #{name.class}" unless c # " #{@classes}"
      #puts "CLAZZ, #{name} #{c.get_type.get_length}" if c
      c
    end

    # get or create the class by the (symbol) name
    # notice that this method of creating classes implies Object superclass
    def get_class_by_name! name
      c = get_class_by_name(name)
      return c if c
      create_class name
    end

    # this is the way to instantiate classes (not Parfait::Class.new)
    # so we get and keep exactly one per name
    def create_class( name , superclass = nil )
      raise "create_class #{name.class}" unless name.is_a? Symbol
      superclass = :Object unless superclass
      raise "create_class #{superclass.class}" unless superclass.is_a? Symbol
      type = get_class_by_name(superclass).instance_type
      c = Class.new(name , superclass , type )
      @classes[name] = c
    end

    def sof_reference_name
      "space"
    end

  end
  # ObjectSpace
  # :each_object, :garbage_collect, :define_finalizer, :undefine_finalizer, :_id2ref, :count_objects
end
