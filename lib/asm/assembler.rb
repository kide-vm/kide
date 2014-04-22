
module Asm
  ERRSTR_NUMERIC_TOO_LARGE = 'cannot fit numeric literal argument in operand'
  ERRSTR_INVALID_ARG = 'invalid operand argument'

  class Assembler
    def initialize
      @objects = []
      @position = -1 # marks not set
      @label_objects = []
      #@relocations = []
    end
    attr_reader :relocations, :objects , :position

    def add_object(obj)
      obj.at(@position)
      @position += obj.length
      @objects << obj
    end
    

    def assemble(io)
      @objects.each do |obj|
        obj.assemble io, self
      end
    end
  end

#  class Relocation
#    def initialize(pos, label, type, handler)
#      @position = pos
#      @label = label
#      @type = type
#      @handler = handler
#    end
#    attr_reader :position, :label, :type, :handler
#  end

#old assemble function
#def assemble(io)
#  @objects.each do |obj|
#    obj.assemble io, self
#  end
#  @relocations.delete_if do |reloc|
#    io.seek reloc.position
#    #puts "reloc #{reloc.inspect}"
#    if (reloc.label.extern?)
#      reloc.handler.call(io, io.tell, reloc.type)
#    else
#      reloc.handler.call(io, reloc.label.address, reloc.type)
#    end
#   not reloc.label.extern?
   #end  
#end
#def add_relocation(*args)
#  reloc = Asm::Relocation.new(*args)
#  #raise "reloc #{reloc.inspect}"
#  @relocations << reloc
#end

end

