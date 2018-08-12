module Parfait

  # Callable is an interface that Blocks and CallableMethods follow
  #
  # This mean they share the following state
  # - self_type: The type of self, ie an object describing instance valriable names
  # - arguments_type: A type object describing the arguments (name+types) to be passed
  # - frame_type:  A type object describing the local variables that the method has
  # - binary:  The binary (jumpable) code that instructions get assembled into
  # - blocks: linked list of blocks inside this method/block
  # - next_callable: next block/method at same level
  #
  class Callable < Object

    attr :type, :self_type , :arguments_type , :frame_type , :binary
    attr :blocks , :name
    attr :next_callable

    def self.type_length
      8
    end

    def initialize( name , self_type , arguments_type , frame_type)
      super()
      raise "No class #{self}" unless self_type
      raise "For type, not class #{self_type}" unless self_type.is_a?(Type)
      raise "Mixup" unless name.is_a?(Symbol)
      self.name = name
      self.self_type = self_type
      init(arguments_type, frame_type)
    end

    def ==(other)
      self_type == other.self_type
    end

    # (re) init with given args and frame types
    def init(arguments_type, frame_type)
      raise "Wrong argument type, expect Type not #{arguments_type.class}" unless arguments_type.is_a? Type
      raise "Wrong frame type, expect Type not #{frame_type.class}" unless frame_type.is_a? Type
      self.arguments_type = arguments_type
      self.frame_type = frame_type
      self.binary = BinaryCode.new(0)
    end

    # determine if method has a local variable or tmp (anonymous local) by given name
    def has_local( name )
      raise "has_local #{name}.#{name.class}" unless name.is_a? Symbol
      frame_type.variable_index( name )
    end

    def add_local( name , type )
      index = has_local( name )
      return index if index
      self.frame_type = frame_type.add_instance_variable(name,type)
    end

    def each_binary( &block )
      bin = binary
      while(bin) do
        block.call( bin )
        bin = bin.next_code
      end
    end

    def set_next( method )
      self.next_callable = method
    end

  end
end
