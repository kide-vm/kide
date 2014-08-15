Array.class_eval do
  def to_sof(io , members , level)
    each_with_index do |object , i|
      io.write(" " * level) unless i == 0
      io.write("-")
      members.output(io , object)
      io.write("\n")
    end
  end
end
