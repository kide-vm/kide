# The Vm Module expresses a medium level virtual machine.
# It is the level between the higher ruby abstraction and the lower risc level.
#
# Historically it has grown out of a language abtraction that was not unlike c,
# in that it has tyes and everything is known at compile time.
# No method dispatch, just calling.
# In some ways it is more like c++ as it knows about classes and in fact everything is an
# object. 
module Vm
end
require_relative "vm/tree"
require_relative "vm/method_compiler"
