Array.class_eval do
  def add_sof(members , level)
    each do |o|
      members.add(o , level + 1)
    end
  end
  def to_sof(io , members)
    each do |object|
      io.write("\n")
      members.output(io , object)
    end
  end
end
