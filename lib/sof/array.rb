Array.class_eval do
  def to_sof_node(writer , level)
    node = Sof::ArrayNode.new()
    each do |object|
      node.add writer.to_sof_node( object )
    end
    node
  end
end
module Sof
  class ArrayNode < Node
    def initialize 
      @children = []
    end
    attr_reader  :children
    def add c
      @children << c
    end
    def out io , level = 0
      long_out(io , level)
    end
    
    private
    def long_out io , level
      indent = " " * level
      @children.each_with_index do |child , i|
        io.write "\n#{indent}" unless i == 0
        io.write "-"
        child.out(io , level + 1)
      end
    end
  end
end