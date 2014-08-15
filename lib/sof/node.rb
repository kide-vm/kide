# We transform objects into a tree of nodes

module Sof
  class Node
    def initialize head
      @head = head
    end
    attr_accessor :head , :children
    def add child
      child = Node.new(child) if(child.is_a? String)
      @children = [] if(@children.nil?)
      @children << child
    end

    def out io , level = 0
      io.write head
      return unless @children
      first = @children[0]
      io.write " "
      first.out(io , level + 1)
      indent = " " * level      
      @children.each do |child|
        next if child == first  # done already
        io.write indent
        io.write "-"
        child.out(io , level + 1)
      end
    end
  end
end
