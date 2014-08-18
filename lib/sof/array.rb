module Sof
  class ArrayNode < Node
    def initialize ref
      super(ref)
      @children = []
    end
    attr_reader  :children
    def add c
      @children << c
    end
    def out io , level = 0
      super
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
Array.class_eval do
  def to_sof_node(writer , level , ref )
    node = Sof::ArrayNode.new(ref)
    each do |object|
      node.add writer.to_sof_node( object , level + 1)
    end
    node
  end
end
