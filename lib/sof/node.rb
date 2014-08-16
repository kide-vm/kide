# We transform objects into a tree of nodes

module Sof
  class Node
    def initialize head
      @head = head
    end
    attr_accessor :head
    def out io , level
      io.write(head) if head
    end
  end
  
  class ChildrenNode < Node
    def initialize head
      super(head)
      @children = []
    end
    attr_accessor  :children

    def add child
      child = Node.new(child) if(child.is_a? String)
      @children << child
    end

    def out io , level = 0
      super
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
