
(puts("Usage: #{} SOURCE"); exit) if ARGV.empty?

require_relative 'helper'
require 'vm/compiler'

Thnad::Compiler.new(ARGV.first).compile
