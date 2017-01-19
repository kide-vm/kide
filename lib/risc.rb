class String
  def camelize
    self.split("_").collect( &:capitalize ).join
  end
end


require "risc/padding"
require "risc/positioned"
require "vm"

require "parfait"
require "risc/machine"

class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end


require "risc/instruction"
require "risc/register_value"
require "risc/assembler"
