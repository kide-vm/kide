Array.class_eval do
  def to_sof_node(writer , level)
    node = Sof::ArrayNode.new()
    each do |object|
      node.add writer.to_sof_node( object )
    end
    node
  end
end
