module Sof
  class Writer
    def initialize members
      @members = members
    end

    def write
      io = StringIO.new
      output io , @members.root
      io.string
    end

    def output io , object
      if Members.is_value?(object)
        object.to_sof(io , self)
        return
      end
      occurence = @members.objects[object]
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
      writer = Writer.new(Members.new(object) )
      writer.write
    end
    
  end
end
