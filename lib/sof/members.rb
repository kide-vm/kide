module Sof
  
  class Members
    def initialize root
      @root = root
      @counter = 1
      @objects = {}
      add(root ,0 )
    end
    attr_reader :objects , :root
    
    def add object , level
      return if Members.is_value?(object)
      if( @objects.has_key?(object) )
        occurence = @objects[object]
        occurence.level = level if occurence.level > level
        return
      end
      o = Occurence.new( object , @counter , level )
      @objects[object] = o
      @counter = @counter + 1
      attributes = attributes_for(object)
      attributes.each do |a|
        val = object.instance_variable_get "@#{a}".to_sym
        add(val , level + 1)
      end
      if( object.is_a? Array )
        object.each do |a|
          add(a , level + 1)
        end
      end
    end

    def self.is_value? o
      return true if o == true
      return true if o == false
      return true if o == nil
      return true if o.class == Fixnum
      return true if o.class == Symbol
      return true if o.class == String
      return false
    end

    def attributes_for object
      if( Known.is( object.class ))
        Known.attributes(object.class)
      else
        object.instance_variables.collect{|i| i.to_s[1..-1].to_sym } # chop of @
      end
    end
  end
end
