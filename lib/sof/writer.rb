module Sof
  class Writer
    include Util
    def initialize members
      @members = members
    end

    def write
      io = StringIO.new
      output io , @members.root
      io.string
    end

    def output io , object
      if is_value?(object)
        object.to_sof(io , self)
        return
      end
      occurence = @members.objects[object]
      raise "no object #{object}" unless occurence
      if(object.respond_to? :to_sof) #mainly meant for arrays and hashes
        object.to_sof(io , self , occurence.level)
      else
        object_sof(object , io , occurence.level)
      end
    end

    def object_sof( object , io , level)
      io.write object.class.name
      io.write "("
      attributes = attributes_for(object)
      attributes.each_with_index do |a , i|
        val = get_value(object , a)
        next unless is_value?(val)
        io.write( a )
        io.write( ": " )
        output( io , val)
        io.write(" ,") unless i == (attributes.length - 1)
      end
      io.puts ")"
      attributes.each_with_index do |a , i|
        val = get_value(object , a)
        next if is_value?(val)
        io.write " " * (level+1)
        io.write "-"
        io.write( a )
        io.write( ": " )
        output( io , val)
      end
    end

    def self.write object
      writer = Writer.new(Members.new(object) )
      writer.write
    end
    
  end
end
