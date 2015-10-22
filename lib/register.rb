require "parfait"
require "register/machine"
#if we are in the ruby run-time / generating an executable
require "register/positioned"
require "register/padding"
require "register/parfait_adapter"

require "phisol/compiler"
require "register/method_source"


class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end

require "register/instruction"
require "register/register_value"
require "register/assembler"
