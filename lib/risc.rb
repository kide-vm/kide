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

# See risc/Readme
module Risc
  # module method to reset, and init
  def self.boot!
    Position.clear_positions
  end
end

require_relative "risc/position/position"
require_relative "risc/platform"
require_relative "risc/parfait_boot"
require_relative "risc/parfait_adapter"
require "parfait"
require_relative "risc/linker"
require_relative "risc/callable_compiler"
require_relative "risc/method_compiler"
require_relative "risc/block_compiler"
require_relative "risc/assembler"
require_relative "risc/risc_collection"

class Integer
  def fits_u8?
    self >= 0 and self <= 255
  end
end


require_relative "risc/instruction"
require_relative "risc/register_value"
require_relative "risc/text_writer"
require_relative "risc/builder"
