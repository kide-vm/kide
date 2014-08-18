module Sof
  
  class Members
    include Util
    
    def initialize root
      @root = root
      @counter = 1
      @objects = {}
      add(root , 0)
    end
    attr_reader :objects , :root
    
    def add object , level
      return if is_value?(object)
      if( occurence = @objects[object] )
        #puts "reset level #{level} at #{occurence.level}"
        occurence.level = level if occurence.level > level
        return
      end
      o = Occurence.new( object , @counter , level )
      @objects[object] = o
      @counter = @counter + 1
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
