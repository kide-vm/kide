module Register
  class LinkSlot
    def initialize position
      @position = position
      raise "Nil not is not an allowed position" unless position  
      @length = 0
    end
    attr_accessor :position , :length , :layout
  end
  class Linker
    def initialize
      @objects = {}
    end

    def get_slot(object)
      @objects[object.object_id]      
    end

    def link_object(object , at)
      slot = @objects[object.object_id]
      unless slot
        slot = LinkSlot.new at
        @objects[object.object_id] = slot
      end
      if object.is_a? Instruction
        length = 4
      else
        slot.layout =  layout_for(object)
        clazz = object.class.name.split("::").last
        length = send("link_#{clazz}".to_sym , object , at)
      end
      slot.length = length
      length
    end

    def layout_for(object)
      case object
      when Array , Symbol , String , Virtual::CompiledMethod , Virtual::Block , Virtual::StringConstant
        { :names => [] , :types => []}
      when Hash
        { :names => [:keys,:values] , :types => [Virtual::Reference,Virtual::Reference]}
      when Virtual::BootClass
        { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
      when Virtual::BootSpace
        { :names => [:classes,:objects] , :types => [Virtual::Reference,Virtual::Reference]}
      else
        raise "linker encounters unknown class #{object.class}"
      end
    end

    def link_self(object , at)
      slot = @objects[object.object_id]
      layout = slot.layout
      length = link_object(layout[:names] , at)
      length + members( layout[:names].length) # 2 for type and layout
    end

    def link_Array( array , at)
      length = 0
      array.each do |elem| 
        length += link_object(elem , at + length)
      end
      # also array has constant overhead, the members helper fixes it to multiple of 8
      members(length)
    end

    def link_Hash( hash , at)
      length = link_object(hash.keys , at)
      length += link_object(hash.values , at + length)
      length += link_self(hash , at + length)
      members(length)
    end

    def link_BootSpace(space , at)
      length = link_object( space.classes , at + length )
      length += link_object(space.objects , at + length)
      length + members( 2 )
    end

    def link_BootClass(clazz , at)
      length = link_object(clazz.name , at + length)
      length += link_object(clazz.super_class_name , at + length)
      length += link_object(clazz.instance_methods , at + length)
      length + members(3)
    end

    def link_CompiledMethod(method , at)
      length = members(2)
      length += link_object(method.name ,at + length)
      # NOT an ARRAY, just a bag of bytes
      method.blocks.each do |block|
        length += link_object( block ,at + length)
      end
      length
    end

    def link_Block(block , at)
      len = 0 
      # NOT linking as an array, as we need the strem that makes the method
      block.codes.each do |code|
        len += link_object(code , at + len)
      end
      len
    end
    
    def link_String( str , at)
      return members(str.length / 4)
    end

    def link_Symbol(sym , at)
      return link_String(sym.to_s , at)
    end

    def link_StringConstant( sc , at)
      return link_String(sc.string,at)
    end
    
    
    # objects only come in lengths of multiple of 8
    # but there is a constant overhead of 2, one for type, one for layout
    # and as we would have to subtract 1 to make it work without overhead, we now have to add 1
    def members len
      8 * (1 + (len + 1) / 8)
    end
    
  end
end