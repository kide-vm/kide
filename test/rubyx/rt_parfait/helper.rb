#
# This is the helper for the runtime tests.
# That means the code is parsed and helps execute rt tests for parfait.
# (also means this is never loaded at test time)
#
# The aim is to us the tests at /tests/parfait to test parfait at runtime
# To achieve that, we implement the ParfaitTest, as a mini MiniTest

class ParfaitTest
  def setup
    @space = Object.object_space # this mapping wil have to be added to compiler
  end
  def assert(arg)
    return unless(arg)
    "No passed".putstring
    exit(1)
  end
end
