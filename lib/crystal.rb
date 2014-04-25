# parslet is assumed to be checked out at the same level as crystal for now
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', ".." , "parslet",'lib'))
require 'parslet'

require "asm/program"
require "elf/object_writer"
require 'vm/parser'
require 'vm/nodes'
require 'vm/transform'

