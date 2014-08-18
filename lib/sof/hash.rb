module Sof
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

Hash.class_eval do
  def to_sof_node(writer , level)
    node = Sof::HashNode.new()
    each do |key , object|
      k = writer.to_sof_node( key )
      v = writer.to_sof_node( object )
      node.add(k , v)
    end
    node
  end
end

