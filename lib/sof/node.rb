# We transform objects into a tree of nodes

module Sof
  #abstract base class for nodes in the tree
  class Node
    include Util
    # must be able to output to a stream
    def out io ,level
      raise "abstract #{self}"
    end
  end
  
  class SimpleNode < Node
    def initialize data
      @data = data
    end
    attr_reader :data
    def out io , level
      io.write(data)
    end
  end
  
  class ObjectNode < Node
    def initialize data
      @data = data 
      @children = []
    end
    attr_reader   :children ,  :data
    def add k , v
      @children << [k,v]
    end
    def out io , level = 0
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
