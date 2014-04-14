class Asm::Arm::AddrTableObject
  def initialize
    @table = []
    @const = []
  end
  
  # TODO don't create new entry if there's already an entry for the same label/const
  def add_label(label)
    d = [label, Asm::LabelObject.new]
    @table << d
    d[1]
  end
  
  def add_const(const)
    d = [const, Asm::LabelObject.new]
    @const << d
    d[1]
  end
  
  def assemble(io, as)
    @table.each do |pair|
      target_label, here_label = *pair
      here_label.assemble io, as
      as.add_relocation io.tell, target_label, Asm::Arm::R_ARM_ABS32,
                        Asm::Arm::Instruction::RelocHandler
      io.write_uint32 0
    end
    @const.each do |pair|
      const, here_label = *pair
      here_label.assemble io, as
      io.write_uint32 const
    end
  end
end
