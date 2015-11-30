
# A Space is a collection of pages. It stores objects, the data for the objects,
# not references. See Page for more detail.

# Pages are stored by the object size they represent in a hash.

# Space and Page work together in making *new* objects available.
# "New" is slightly misleading in that normal operation only ever
# recycles objects.

module Parfait
  # The Space contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main".
  # This _must be supplied by the compled code (similar to c)
  # There is a start and exit block that call main, which receives an List of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  class Space < Object

    def initialize
      raise "Space can not be instantiated by new, you'd need a space to do so. Chicken and egg"
    end
    attributes [:classes , :first_message]

    # need a two phase init for the object space (and generally parfait) because the space
    # is an interconnected graph, so not everthing is ready
    def late_init
      message = Message.new(nil)
      50.times do
        self.first_message = Message.new message
        #puts "INIT caller #{message.object_id} to #{self.first_message.object_id}"
        message.set_caller self.first_message
        message = self.first_message
      end
    end

    @@object_space = nil
    # Make the object space globally available
    def self.object_space
      @@object_space
    end
    # TODO Must get rid of the setter
    def self.set_object_space space
      @@object_space = space
    end

    def get_main
      kernel = get_class_by_name :Space
      kernel.get_instance_method :main
    end

    def get_init
      kernel = get_class_by_name :Kernel
      kernel.get_instance_method :__init__
    end

    # get a class by name (symbol)
    # return nili if no such class. Use bang version if create should be implicit
    def get_class_by_name name
      raise "get_class_by_name #{name}.#{name.class}" unless name.is_a?(Symbol)
      c = self.classes[name]
      #puts "MISS, no class #{name} #{name.class}" unless c # " #{self.classes}"
      #puts "CLAZZ, #{name} #{c.get_layout.get_length}" if c
      c
    end

    # get or create the class by the (symbol) name
    # notice that this method of creating classes implies Object superclass
    def get_class_by_name! name
      c = get_class_by_name(name)
      return c if c
      create_class name , get_class_by_name(:Object)
    end

    # this is the way to instantiate classes (not Parfait::Class.new)
    # so we get and keep exactly one per name
    def create_class name , superclass
      raise "create_class #{name.class}" unless name.is_a? Symbol
      c = Class.new(name , superclass)
      self.classes[name] = c
    end

    def sof_reference_name
      "space"
    end

  end
  # ObjectSpace
  # :each_object, :garbage_collect, :define_finalizer, :undefine_finalizer, :_id2ref, :count_objects
end
