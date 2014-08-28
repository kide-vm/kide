# almost simplest hash imaginable. make good use of arrays
class Hash
  def initialize
    @keys = Array.new()
    @values = Array.new()
  end
  def empty?
    @keys.empty?
  end

  def length()
    return @keys.length()
  end

  def get(key)
    index = key_index(key)
    if( index )
      @values[index]
    else
      nil
    end
  end

  def key_index(key)
    len = @keys.length()
    index = 0
    found = nil
    while(index < len)
      if( @keys[index] == key)
        found = index
        break
      end
      index += 1
    end
    found
  end

  def set(key , value)
    index = key_index(key)
    if( index )
      @keys[index] = value
    else
      @keys.push(key)
      @values.push(value)
    end
    value
  end
end

