require 'parslet'

module Parfait
  eval(File.open("./lib/parfait/hash.rb").read)
end

require "compiler"
require "stream_reader"
require "elf/object_writer"
require 'salama-reader'
require 'parser/transform'
require "salama-object-file"
require "virtual/machine"
require "register/register_machine"
require "arm/arm_machine"
