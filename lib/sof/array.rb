Array.class_eval do
  def to_sof(io , members)
    each do |object|
      io.write("\n")
      members.output(io , object)
    end
  end
end
