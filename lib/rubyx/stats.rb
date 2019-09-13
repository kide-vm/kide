class RubyXC < Thor

  desc "stats FILE" , "Give object statistics on compiled FILE"
  long_desc <<-LONGDESC
      Compile the give file name and print statistics on the binary.
      A Binary file is in essence an ObjectSpace, ie a collection of objects.

      This command tells you how many objects of each kind, the amount of bytes
      objects of that class take, and the total amount of bytes taken.

      Together with various options this may be used to tune the executable, or just fyi.
    LONGDESC
  def stats(file)
    compile(file)
    by_class = Hash.new(0)
    Risc::Position.positions.each  do |object , _ |
      by_class[object.class] += 1 if Risc::Position.is_object(object)
    end
    obj, total = 0 , 0
    by_class.each do |clazz , num|
      dis =  (clazz == Symbol) ? 8 : clazz.memory_size
      puts clazz.name.split("::").last + " == #{num}   / #{num*dis}"
      obj += num
      total += num * dis
    end
    puts "\nTotal Objects=#{obj}  Words=#{total}"
  end
end
