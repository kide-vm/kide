# We transform objects into a tree of nodes

module Sof
  #abstract base class for nodes in the tree
  # may be referenced (should be a simple name or number)
  class Node
    def initialize referenced
      @referenced = referenced
    end
    include Util
    # must be able to output to a stream
    def out io ,level
      io.write "&#{referenced} " if referenced
    end
    attr_reader :referenced
  end
  
  class SimpleNode < Node
    def initialize data
      super(nil)
      @data = data
    end
    attr_reader :data
    def out io , level
      io.write(data)
    end
  end
  
  class ObjectNode < Node
    def initialize data , ref
      super(ref)
      @data = data 
      @children = []
    end
    attr_reader   :children ,  :data
    def add k , v
      @children << [k,v]
    end
    def out io , level = 0
      super
      io.write(@data)
      indent = " " * (level + 1)
      @children.each_with_index do |child , i|
        k , v = child
        io.write "\n#{indent}"
        k.out(io , level + 2)
        io.write " "
        v.out(io , level + 2)
      end
    end
  end
end
