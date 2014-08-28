class List

  def initialize
    @next = nil
  end
  def empty?
    @next.nil?
  end

  def get(key)
    @next ?  @next.get(key) : nil
  end

  def set(key , value)
    @next ? @next.set(key,value) : @next = Node.new(key,value)
    value
  end
end

class Node < List
  def initialize(key,value)
    @key = key
    @value = value
  end
  def get(key)
    @key == key ? @value : super(key)
  end
  def set(key,value)
    @key == key ? @value = value : super(key,value)
  end
end

# https://www.youtube.com/watch?v=HJ-719EGIts