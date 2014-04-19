require_relative "relocation"

module Asm
  ERRSTR_NUMERIC_TOO_LARGE = 'cannot fit numeric literal argument in operand'
  ERRSTR_INVALID_ARG = 'invalid operand argument'

  class Assembler
    def initialize
      @objects = []
      @label_objects = []
      @relocations = []
    end
    attr_reader :relocations, :objects

    def add_object(obj)
      @objects << obj
    end

    def add_relocation(*args)
      @relocations << Asm::Relocation.new(*args)
    end

    def assemble(io)
      @objects.each do |obj|
        obj.assemble io, self
      end

      @relocations.delete_if do |reloc|
        io.seek reloc.position
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

