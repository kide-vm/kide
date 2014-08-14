module Sof
  
  class Members
    def initialize root
      @root = root
      @counter = 1
      @objects = {}
      add(root ,0 )
    end
    attr_reader :objects
    
    def add object , level
      if( @objects.has_key?(object) )
        occurence = @objects[object]
        occurence.level = level if occurence.level > level
      else
        o = Occurence.new( object , @counter , level )
        @objects[object] = o
        c = @counter
        @counter = @counter + 1
        if( object.respond_to?(:attributes))
          object.attributes.each do |a|
            val = object.send a
            add(val , level + 1)
          end
        elsif not value?(object)
          object.add_sof(self , level)
        end
      end
    end

    def value? o
      return true if o == true
      return true if o == false
      return true if o == nil
      return true if o.class == Fixnum
      return true if o.class == Symbol
      return true if o.class == String
      return false
    end
    def write
      io = StringIO.new
      output io , @root
      io.string
    end

    def output io , object
      occurence = @objects[object]
      raise "no object #{object}" unless occurence
      indent = " " * occurence.level
      io.write indent
      if(object.respond_to? :to_sof)
        object.to_sof(io , self)
      else
        io.write object.class.name
        if( object.respond_to?(:attributes))
          object.attributes.each do |a|
            val = object.send a
            io.write( a )
            io.write( " " )
            output( io , val)
          end
          io.puts ""
        else 
          raise "General object not supported (yet), need attribute method #{object}"
        end
      end
    end

    def self.write object
      members = Members.new object
      members.write
    end
  end
end
