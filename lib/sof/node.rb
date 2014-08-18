# We transform objects into a tree of nodes

module Sof
  #abstract base class for nodes in the tree
  class Node
    # must be able to output to a stream
    def out io ,level
      raise "abstract #{self}"
    end
  end
  
  class SimpleNode < Node
    def initialize data
      @data = data
    end
    attr_accessor :data
    def out io , level
      io.write(data)
    end
  end
  
  class ArrayNode < Node
    def initialize 
      @children = []
    end
    attr_reader  :children
    def add c
      @children << c
    end
    def out io , level = 0
      indent = " " * level
      @children.each_with_index do |child , i|
        io.write "\n#{indent}" unless i == 0
        io.write "-"
        child.out(io , level + 1)
      end
    end
  end
  class ObjectNode < Node
    def initialize data
      @data = data 
      @children = []
    end
    attr_reader   :children
    attr_accessor :data
    def add k , v
      @children << [k,v]
    end
    def out io , level = 0
      io.write(@data)
      indent = " " * level
      @children.each_with_index do |child , i|
        k , v = child
        io.write "\n#{indent}" 
        io.write ".."
        k.out(io , level + 1)
        v.out(io , level + 1)
      end
    end
  end
  class HashNode < Node
    def initialize 
      @children = []
    end
    attr_reader  :children
    def add key , val
      @children << [key,val]
    end
    def out io , level = 0
      indent = " " * level
      @children.each_with_index do |child , i|
        key , val = child
        io.write "\n#{indent}" unless i == 0
        io.write "-"
        key.out(io , level + 1)
        io.write ": "
        val.out(io , level + 1)
      end
    end
  end
end
