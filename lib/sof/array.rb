Array.class_eval do
  def to_sof(io , members , level)
    each do |object|
      io.write(" " * level)
      io.write("-")
      members.output(io , object)
      io.write("\n")
    end
  end
end
