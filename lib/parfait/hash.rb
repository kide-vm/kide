# almost simplest hash imaginable. make good use of arrays
module Parfait
end
class Parfait::Hash
  def initialize
    @keys = Array.new()
    @values = Array.new()
  end
  def values()
    @values
  end
  def keys()
    @keys
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
  def [](key)
    get(key)
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
  def []=(key,val)
    set(key,val)
  end
end

