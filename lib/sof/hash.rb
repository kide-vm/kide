Hash.class_eval do
  def to_sof_node(members , level)
    node = Sof::NodeList.new(nil)
    each do |key , object|
      k = key.to_sof() + ": "
      v = members.to_sof_node( object )
    end
  end
end
