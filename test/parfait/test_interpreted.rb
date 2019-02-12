# Test Parfait by parsing it and the tests, and interpreting it.
# (Later also run on arm, much like the mains)
#
# The difference betwen the running parfait and compiled parfait is namespace.
#
# In the running interpreter (the one that runs the tests/compiler), Parfait is namespaced
# to Parfait, because we define Class/Object/Hash/String etc. All that basic stuff that
# is not namespaced in ruby and thus would clash in the running interpreter.
#
# Which leads straight to the point, that in the compiled code parfait is not namespaced.
# Parfait files are actually without namespace, and the namespace is wrapped from the
# outside, so we are good to just parse parfait files.
#
# But the tests are defined for the interpreter (also namespaced) and minitest is used,
# so we can not just parse the tests. Instead we parse and rewrite the test (removing the
# namespace and defining a mini mintest while we are there),
# and then write a single main out. And interpret that.
# For each test defined in Parfait.
require_relative "helper"

module Parfait

  class InterpretParfait < MiniTest::Test
    def setup
      parfait = ["object"]
      parfait.each do |file|
        ruby = File.read("./test/parfait/test_#{file}.rb")
        not_scoped = ParfaitRewriter.new.rewrite(ruby)
        #puts not_scoped
      end
    end

    def test_any

    end
  end
end
