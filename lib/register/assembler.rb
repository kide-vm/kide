
module Register
  class LinkSlot
    def initialize position
      @position = position
      raise "Nil not is not an allowed position" unless position  
      @length = 0
    end
    attr_accessor :position , :length , :layout
  end
  
  class Assembler

    def initialize space
      @space = space
      @objects = {}
    end

    def link
      link_object(@space , 0)
    end

    def get_slot(object)
      @objects[object.object_id]      
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

    def write_ref object
      slot = get_slot(object)
      raise "Object not linked #{object.inspect}" unless slot
      @stream.write_uint32 slot.position
    end

    def assemble
      link
      @stream = StringIO.new
      assemble_object( @space )
      puts "leng #{@stream.length}"
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

    def assemble_object object
      slot = get_slot(object)
      raise "Object not linked #{object_id}=>#{object.class}" unless slot
      if object.is_a? Instruction
        object.assemble( @stream , self )
      else
        clazz = object.class.name.split("::").last
        len = send("assemble_#{clazz}".to_sym , object)
      end
    end

    def link_self(object , at)
      slot = @objects[object.object_id]
      layout = slot.layout
      length = link_object(layout[:names] , at)
      length + members( layout[:names].length) # 2 for type and layout
    end

    # assemble the instance variables of the object
    def assemble_self( object )
      slot = get_slot(object)
      raise "Object not linked #{object.inspect}" unless slot
      layout = slot.layout
      @stream.write_uint32( 0 ) #TODO
      @stream.write_uint32( slot.position ) #ref
      layout.each do |name|
        write_ref(name)
      end
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

    def assemble_Hash hash
      assemble_self( hash )
      hash.each do |key , val|
        assemble_object(key)
        assemble_object(val)
      end
    end

    def link_BootSpace(space , at)
      length = link_object( space.classes , at )
      length += link_object(space.objects , at + length)
      length + members( 2 )
    end

    def assemble_BootSpace(space)
      # assemble in the same order as linked
      assemble_object(space.classes)
      assemble_object(space.objects)
      assemble_self(space)
    end

    def link_BootClass(clazz , at)
      length = link_object(clazz.name , at )
      length += link_object(clazz.super_class_name , at + length)
      length += link_object(clazz.instance_methods , at + length)
      length + members(3)
    end

    def assemble_BootClass(clazz)
      assemble_object(clazz.name)
      assemble_object(clazz.super_class_name)
      clazz.instance_methods.each do |meth|
        assemble_object(meth)
      end
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

    def assemble_CompiledMethod(method)
      assemble_object(method.name)
      method.blocks.each do |block|
        assemble_object(block)
      end
    end

    def assemble_Block(block)
      block.codes.each do |code|
        assemble_object(code)
      end
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

    def assemble_String( str )
      @stream.write str
    end

    def assemble_Symbol(sym)
      return assemble_String(sym.to_s)
    end

    def assemble_StringConstant( sc)
      return assemble_String(sc.string)
    end
  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
