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
    def initialize head
      @head = head
    end
    attr_accessor :head
    def out io , level
      io.write(head) if head
    end
  end
  
  class NodeList < Node
    def initialize
      @children = []
    end
    attr_accessor  :children

    def add child
      child = SimpleNode.new(child) if(child.is_a? String)
      @children << child
    end

    def out io , level = 0
      return if @children.empty?
      first = @children.first
      io.write "-"
      first.out(io , level + 1)
      indent = " " * level      
      @children.each_with_index do |child , i|
        next if i == 0  # done already
        io.write "\n"
        io.write indent
        io.write "-"
        child.out(io , level + 1)
      end
    end
  end
end
