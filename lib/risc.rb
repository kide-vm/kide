class String
  def camelise
    self.split("_").collect{|str| str.capitalize_first }.join
  end
  def capitalize_first
    self[0].capitalize + self[1..-1]
  end
end
class Class
  def short_name
    self.name.split("::").last
  end
end

# The RiscMachine, is an abstract machine with registers. Think of it as an arm machine with
# normal instruction names. It is not however an abstraction of existing hardware, but only
# of that subset that we need.
# See risc/Readme
module Risc
end

require_relative "risc/padding"
require_relative "risc/position"
require_relative "risc/platform"

require "parfait"
require_relative "risc/machine"
require_relative "risc/method_compiler"

class Fixnum
  def fits_u8?
    self >= 0 and self <= 255
  end
end


require_relative "risc/instruction"
require_relative "risc/risc_value"
require_relative "risc/text_writer"
require_relative "risc/builtin/space"
require_relative "risc/builder"
