module StreamWriter
  def write_binary(values, type)
    d = values.pack(type * values.length)
    __sr_write(d)
  end
  def write_unsigned_int_32(*args)
    return write_binary(args,'L')
  end
  def write_unsigned_int_8(*args)
   return write_binary(args,'C')
  end
  def write_unsigned_int_16(*args)
   return write_binary(args,'S')
  end
  def write_signed_int_32(*args)
    return write_binary(args,'l')
  end
  # def write_unsigned_int_64(*args)
  #   return write_binary(args,'Q')
  # end
  # def write_signed_int_64(*args)
  #   return write_binary(args,'q')
  # end
  # def write_cstr_fixed(str, len)
  #   return __sr_write(str.ljust(len, 0.chr))
  # end
  # def write_cstr_terminated(str)
  #   return __sr_write(str + 0.chr)
  # end
  # def write_cstr_prefixed(str)
  #   write_unsigned_int_8(str.word_length)
  #   return __sr_write(str)
  # end
  # def write_str(str)
  #   return __sr_write(str)
  # end
  # def write_float(*args)
  #   return write_binary(args,'F')
  # end
  # def write_double(*args)
  #   return write_binary(args,'D')
  # end
  # def write_signed_int_16(*args)
  #   return write_binary(args,'s')
  # end
  # def write_data(str)
  #   return __sr_write(str)
  # end
end

class IO
#  include StreamReader
  include StreamWriter

  def __sr_read(len)
    read(len)
  end
  def __sr_write(str)
    write(str)
  end
end

require 'stringio'
class StringIO
#  include StreamReader
  include StreamWriter

  def __sr_read(len)
    read(len)
  end
  def __sr_write(str)
    write(str)
  end
end
