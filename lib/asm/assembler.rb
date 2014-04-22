
module Asm
  ERRSTR_NUMERIC_TOO_LARGE = 'cannot fit numeric literal argument in operand'
  ERRSTR_INVALID_ARG = 'invalid operand argument'

  class Assembler
    def initialize
      @values = []
      @position = -1 # marks not set
      @labels = []
      @string_table = {}
      #@relocations = []
    end
    attr_reader :relocations, :values , :position 

    def add_string str
      value = @string_table[str]
      return value if value
      data = Asm::DataObject.new(str)
      add_value data
      @string_table[str] = data
    end
    
    def strings
      @string_table.values
    end
    
    def add_value(val)
      val.at(@position)
      @position += val.length
      @values << val
    end
    
    def label
      label = Asm::Arm::GeneratorLabel.new(self)
      @labels << label
      label 
    end

    def label!
      label.set!
    end

    def assemble(io)
      @values.each do |obj|
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
#  @values.each do |obj|
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

