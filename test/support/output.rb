module Output
  def class_list(all)
    str = all.join(", ").gsub("Risc::","").to_s
    str = str.split(",").each_slice(5).collect { |line|  line.join(",") + ","}
    str[0] = "[#{str[0]}"
    str[-1] = "#{str[-1]}]"
    ret = ""
    str.each_with_index { |line,index| ret += "                #{line} ##{index*5 + 5}\n"}
    ret
  end
end
