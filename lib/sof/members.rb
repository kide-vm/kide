module Sof
  
  class Members
    include Util
    
    def initialize root
      @root = root
      @counter = 1
      @objects = {}
      @referenced = false
      add(root , 0)
    end
    attr_reader :objects , :root , :referenced
    
    def add object , level
      return if is_value?(object)
      if( occurence = @objects[object] )
        #puts "reset level #{level} at #{occurence.level}"
        occurence.level = level if occurence.level > level
        occurence.referenced = @counter
        @counter = @counter + 1
        return
      end
      o = Occurence.new( object , level )
      @objects[object] = o
      attributes = attributes_for(object)
      attributes.each do |a|
        val = get_value( object , a)
        add(val , level + 1)
      end
      if( object.is_a? Array )
        object.each do |a|
          add(a , level + 1)
        end
      end
      if( object.is_a? Hash )
        object.each do |a,b|
          add(a , level + 1)
          add(b , level + 1)
        end
      end
    end
  end
end
