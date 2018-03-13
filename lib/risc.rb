class String
  def camelize
    self.split("_").collect( &:capitalize ).join
  end
end


require_relative "risc/padding"
require_relative "risc/positioned"

require "parfait"
require_relative "risc/machine"
require_relative "risc/method_compiler"

class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end


require_relative "risc/instruction"
require_relative "risc/register_value"
require_relative "risc/assembler"
require_relative "risc/builtin/space"
