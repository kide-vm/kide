Hash.class_eval do
  def to_sof_node(writer , level)
    node = Sof::HashNode.new()
    each do |key , object|
      k = writer.to_sof_node(key )
      v = writer.to_sof_node( object )
      node.add(k , v)
    end
    node
  end
end
