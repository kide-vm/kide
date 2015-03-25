require 'parslet'

module Parfait
  eval(File.open("./lib/parfait/hash.rb").read) 
end

require "elf/object_writer"
require 'salama-reader'
require 'parser/transform'
require "sof/all"
require "virtual/machine"
require "register/register_machine"
require "arm/arm_machine"
require "ast/all"
require_relative "stream_reader"
