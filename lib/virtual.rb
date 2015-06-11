require "parfait"
require "virtual/machine"
#if we are in the ruby run-time / generating an executable
require "virtual/positioned"
require "virtual/padding"
require "virtual/parfait_adapter"

require "virtual/compiler"
require "virtual/instruction"
require "virtual/compiled_method_info"
require "virtual/slots/slot"
require "virtual/type"
# the passes _are_ order dependant
require "virtual/passes/minimizer"
require "virtual/passes/collector"
require "virtual/passes/send_implementation"
require "virtual/passes/get_implementation"
require "virtual/passes/enter_implementation"
require "virtual/passes/frame_implementation"

Sof::Volotile.add(Parfait::BinaryCode ,  [:memory])
Sof::Volotile.add(Virtual::Block ,  [:method])
Sof::Volotile.add(Virtual::CompiledMethodInfo ,  [:current])

class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end
