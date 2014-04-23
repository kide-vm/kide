
module Asm

  class Assembler
    def initialize
      @values = []
      @position = 0 # marks not set
      @labels = []
      @string_table = {}
      #@relocations = []
    end
    attr_reader :relocations, :values , :position 

    def add_string str
      value = @string_table[str]
      return value if value
      data = Asm::StringLiteral.new(str)
      @string_table[str] = data
    end
    
    def strings
      @string_table.values
    end
    
    def add_value(val)
      val.at(@position)
      length = val.length
      @position += length
      @values << val
    end
    
    def label
      label = Asm::GeneratorLabel.new(self)
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

end

