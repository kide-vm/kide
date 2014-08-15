Array.class_eval do
  def to_sof_node(members , level)
    node = Sof::Node.new(nil)
    each do |object|
      node.add members.to_sof_node( object )
    end
    node
  end
end
