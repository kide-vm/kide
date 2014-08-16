module Sof
  class Writer
    include Util
    def initialize members
      @members = members
    end

    def write
      node = to_sof_node(@members.root)
      io = StringIO.new
      node.out( io , 0 )
      io.string
    end

    def to_sof_node(object)
      if is_value?(object)
        return Node.new(object.to_sof())
      end
      occurence = @members.objects[object]
      raise "no object #{object}" unless occurence
      if(object.respond_to? :to_sof_node) #mainly meant for arrays and hashes
        object.to_sof_node(self , occurence.level)
      else
        object_sof_node(object , occurence.level)
      end
    end

    def object_sof_node( object , level)
      head = object.class.name + "("
      attributes = attributes_for(object)
      immediate , extended = attributes.partition {|a| is_value?(get_value(object , a) ) }
      head += immediate.collect {|a| "#{a}: #{get_value(object , a).to_sof()}"}.join(", ") + ")"

      node = Node.new(head)
      extended.each do |a|
        val = get_value(object , a)
        node.add to_sof_node(val)
      end
      node
    end

    def self.write object
      writer = Writer.new(Members.new(object) )
      writer.write
    end
    
  end
end
