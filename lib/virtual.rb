require "parfait"
require "virtual/machine"
#if we are in the ruby run-time / generating an executable
require "virtual/positioned"
require "virtual/padding"
require "virtual/parfait_adapter"

require "phisol/compiler"
require "virtual/method_source"


class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end
