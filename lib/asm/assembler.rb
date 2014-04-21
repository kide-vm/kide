require_relative "relocation"

module Asm
  ERRSTR_NUMERIC_TOO_LARGE = 'cannot fit numeric literal argument in operand'
  ERRSTR_INVALID_ARG = 'invalid operand argument'

  class Assembler
    def initialize
      @objects = []
      @position = 0
      @label_objects = []
      @relocations = []
    end
    attr_reader :relocations, :objects

    def add_object(obj)
      obj.at(@position)
      @position += obj.length
      @objects << obj
    end
    
    def add_relocation(*args)
      reloc = Asm::Relocation.new(*args)
      #raise "reloc #{reloc.inspect}"
      @relocations << reloc
    end

    def assemble(io)
      @objects.each do |obj|
        obj.assemble io, self
      end

      @relocations.delete_if do |reloc|
        io.seek reloc.position
        #puts "reloc #{reloc.inspect}"
        if (reloc.label.extern?)
          reloc.handler.call(io, io.tell, reloc.type)
        else
          reloc.handler.call(io, reloc.label.address, reloc.type)
        end
        not reloc.label.extern?
      end
    end
  end
end

