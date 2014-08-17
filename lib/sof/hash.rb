Hash.class_eval do
  def to_sof_node(writer , level)
    node = Sof::NodeList.new()
    each do |key , object|
      k = key.to_sof() + ": "
      v = writer.to_sof_node( object )
      v.data = "#{k}#{v.data}"
      node.add v
    end
    node
  end
end
