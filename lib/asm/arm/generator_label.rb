require "asm/label_object"

class Asm::Arm::GeneratorLabel < Asm::LabelObject
  def initialize(asm)
    @asm = asm
  end
  def at pos
    @position = pos
  end
  def length 
    0
  end
  def set!
    @asm.add_object self
  end
end

class Asm::Arm::GeneratorExternLabel < Asm::LabelObject
  def initialize(name)
    @name = name
    extern!
  end
  attr_reader :name
end
