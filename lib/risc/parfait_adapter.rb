require_relative "fake_memory"


module Parfait
  class Object
    # redefine the runtime version
    def self.new( *args )
      object = self.allocate
      Parfait.set_type_for(object)
      object.send :initialize , *args
      object
    end
    # Setter fo the boot process, only at runtime.
    # only one space exists and it is generated at compile time, not runtime
    def self.set_object_space( space )
      @object_space = space
    end
  end

  def self.set_type_for(object)
    return unless(Parfait.object_space)
    name = object.class.name.split("::").last.to_sym
    # have to grab the class, because we are in the ruby class not the parfait one
    cl = Parfait.object_space.get_class_by_name( name )
    # and have to set the type before we let the object do anything. otherwise boom
    raise "No such class #{name} for #{object}" unless cl
    object.set_type cl.instance_type
  end

  class Space < Object

    # Space can only ever be creared at compile time, not runtime
    def initialize( )
      @classes = Dictionary.new
      @types = Dictionary.new
      @factories = Dictionary.new
      @true_object = Parfait::TrueClass.new
      @false_object = Parfait::FalseClass.new
      @nil_object = Parfait::NilClass.new
    end
    def init_mem(pages)
      [:Integer , :ReturnAddress , :Message].each do |fact_name|
        for_type = classes[fact_name].instance_type
        page_size = pages[fact_name] || 1024
        factory = Factory.new( for_type , page_size )
        factory.get_more
        factories[ fact_name ] = factory
      end
      init_message_chain( factories[ :Message ].reserve  )
      init_message_chain( factories[ :Message ].next_object  )
    end
    def init_message_chain( message )
      prev = nil
      while(message)
        message.initialize
        message._set_caller(prev) if prev
        prev = message
        message = message.next_message
      end
    end
  end
  class DataObject < Object
    def self.allocate
      r = super
      r.instance_variable_set(:@memory , Risc::FakeMemory.new(r ,self.type_length , self.memory_size))
      r
    end
    # 0 -based index
    def get_internal_word(index)
      return super(index) if index < self.class.type_length
      @memory[ index ]
    end

    # 0 -based index
    def set_internal_word(index , value)
      return super(index,value) if index < self.class.type_length
      @memory[ index ] = value
    end
  end

  class Object

    # 0 -based index
    def get_internal_word(index)
      return @type if index == Parfait::TYPE_INDEX
      name = Parfait.name_for_index(self , index)
      return nil unless name
      instance_eval("@#{name}")
    end

    # 0 -based index
    def set_internal_word(index , value)
      name = Parfait.name_for_index(self , index)
      raise "not sym for #{index} in #{self}:#{self.type}:#{name.class}" unless name.is_a?(Symbol)
      instance_eval("@#{name}=value" )
      value
    end

    def self.variable_index( name)
      if(name == :type)
        return Parfait::TYPE_INDEX
      end
      clazz = self.name.split("::").last.to_sym
      type = Parfait.type_names[clazz]
      i = type.keys.index(name)
      raise "no #{name} for #{clazz}:#{type.keys}" unless i
      i + 1
    end

    def self.cattr( *names )
      names.each do |ca|
        class_eval "@@#{ca} = 0"
        class_eval "def self.#{ca}; return @#{ca};end"
        class_eval "def self.#{ca}=(val); @#{ca} = val;end"
      end
    end
  end

  # new list from ruby array to be precise
  def self.new_list array
    list = Parfait::List.new
    list.set_length array.length
    index = 0
    while index < array.length do
      list.set(index , array[index])
      index = index + 1
    end
    list
  end

  # Word from string
  def self.new_word( string )
    string = string.to_s if string.is_a? Symbol
    word = Word.new( string.length )
    string.codepoints.each_with_index do |code , index |
      word.set_char(index , code)
    end
    word
  end

end

class Symbol

  def has_type?
    true
  end
  def get_type
    l = Parfait.object_space.classes[:Word].instance_type
    #puts "LL #{l.class}"
    l
  end
  def padded_length
    Parfait::Object.padded( to_s.length + 4)
  end

end
