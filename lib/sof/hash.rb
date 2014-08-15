Hash.class_eval do
  def to_sof_node(members , level)
    each_with_index do |pair , i|
      key , object = pair
      io.write(" " * level) unless i == 0
      io.write "-"
      members.output( io , key)
      io.write( " " )
      members.output( io , object)
      io.write("\n")
    end
  end
end
