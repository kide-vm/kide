class List

  def initialize
    @next = nil
  end
  def empty?
    @next.nil?
  end

  def get(key)
    if( @next )
      return @next.get(key)
    else
      return nil
    end
  end

  def set(key , value)
    if(@next)
      @next.set(key,value)
    else
      @next = Node.new(key,value)
    end
    value
  end
end

class Node < List
  def initialize(key,value)
    @key = key
    @value = value
  end
  def get(key)
    if(@key == key)
      return @value
    else
      return super(key)
    end
  end
  def set(key,value)
    if(@key == key)
      @value = value
    else
      super(key,value)
    end
  end
end
