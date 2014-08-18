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
      short = true
      children.each do |c|
        short = false unless c.is_a?(SimpleNode)
      end
      if(short and children.length < 7 )
        short_out(io,level)
      else
        long_out(io , level)
      end
    end
    
    private
    def short_out(io,level)
      io.write("[")
      @children.each_with_index do |child , i|
        child.out(io , level + 1)
        io.write ", " unless (i+1) == children.length
      end
      io.write("]")
    end
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
