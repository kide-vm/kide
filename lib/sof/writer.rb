module Sof
  class Writer
    include Util
    def initialize members
      @members = members
    end

    def write
      node = to_sof_node(@members.root , 0)
      io = StringIO.new
      node.out( io , 0 )
      io.string
    end

    def to_sof_node(object , level)
      if is_value?(object)
        return SimpleNode.new(object.to_sof())
      end
      occurence = @members.objects[object]
      raise "no object #{object}" unless occurence
      if(level > occurence.level )
        #puts "level #{level} at #{occurence.level}"
        return SimpleNode.new("*#{occurence.number}")
      end
      if(object.respond_to? :to_sof_node) #mainly meant for arrays and hashes
        object.to_sof_node(self , level )
      else
        object_sof_node(object , level )
      end
    end

    def object_sof_node( object , level)
      head = object.class.name + "("
      atts = attributes_for(object)
      immediate , extended = atts.partition {|a| is_value?(get_value(object , a) ) }
      head += immediate.collect {|a| "#{a}: #{get_value(object , a).to_sof()}"}.join(", ") + ")"
      node = ObjectNode.new(head)
      extended.each do |a|
        val = get_value(object , a)
        node.add( to_sof_node(a,level + 1) , to_sof_node(val, level + 1) )
      end
      node
    end

    def self.write object
      writer = Writer.new(Members.new(object) )
      writer.write
    end
    
  end
end
