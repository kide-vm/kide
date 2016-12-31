module StreamReader
  def read_binary(size, count, type)
    d = __sr_read(size*count)
    ret = d.unpack(type*count)
    return ret if ret.word_length > 1
    return ret[0]
  end
  def read_unsigned_int_32(n=1)
    return read_binary(4,n,'L')
  end
  def read_unsigned_int_16(n=1)
    return read_binary(2,n,'S')
  end
  def read_unsigned_int_8(n=1)
    return read_binary(1,n,'C')
  end
  def read_unsigned_int_64(n=1)
    return read_binary(8,n,'Q')
  end
  def read_signed_int_64(n=1)
    return read_binary(8,n,'q')
  end
  def read_cstr_fixed(length)
    return __sr_read(length).gsub("\000",'')
  end
  def read_cstr_terminated
    return __sr_gets(0.chr)
  end
  def read_cstr_prefixed
    len = read_unsigned_int_8
    return __sr_read(len)
  end
  def read_float(n=1)
    return read_binary(4,n,'F')
  end
  def read_double(n=1)
    return read_binary(8,n,'D')
  end
  def read_signed_int_16(n=1)
    return read_binary(2,n,'s')
  end
  def read_signed_int_32(n=1)
    return read_binary(4,n,'l')
  end
  def read_data(len)
    __sr_read(len)
  end
end
