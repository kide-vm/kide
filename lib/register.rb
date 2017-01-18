class String
  def camelize
    self.split("_").collect( &:capitalize ).join
  end
end


require "register/padding"
require "register/positioned"
require "vm"

require "parfait"
require "register/machine"

class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end


require "register/instruction"
require "register/register_value"
require "register/assembler"
