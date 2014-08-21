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
      occurence = @members.objects[object.object_id]
      raise "no object #{object}" unless occurence
      if(level > occurence.level )
        #puts "ref #{occurence.referenced} level #{level} at #{occurence.level}"
        return SimpleNode.new("*#{occurence.referenced}")
      end
      ref = occurence.referenced
      if(object.respond_to? :to_sof_node) #mainly meant for arrays and hashes
        object.to_sof_node(self , level , ref )
      else
        object_sof_node(object , level , ref )
      end
    end

    def object_sof_node( object , level , ref)
      if( object.is_a? Class )
        return SimpleNode.new( object.name , ref )
      end
      head = object.class.name + "("
      atts = {}
      attributes_for(object).each() do |a| 
        val = get_value(object , a)
        next if val.nil?
        atts[a] =  to_sof_node(val , level + 1)
      end
      immediate , extended = atts.partition {|a,val| val.is_a?(SimpleNode) }
      head += immediate.collect {|a,val| "#{a.to_sof()} => #{val.as_string(level)}"}.join(", ") + ")"
      return SimpleNode.new(head) if( ref.nil? and extended.empty? and head.length < 30 )
      node = ObjectNode.new(head , ref)
      extended.each do |a , val|
        node.add( to_sof_node(a,level + 1) , val )
      end
      node
    end

    def self.write object
      writer = Writer.new(Members.new(object) )
      writer.write
    end
    
  end
end
