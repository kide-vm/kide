require_relative "compiler_helper"

module Virtual
  class TestFields < MiniTest::Test
    include CompilerHelper

    def setup
      Virtual.machine.boot
    end

    def test_field_not_defined
      @root = :field_access
      @string_input = <<HERE
self.a
HERE
      assert_raises(RuntimeError) { check }
    end

    def test_field
      Virtual.machine.space.get_class_by_name(:Object).object_layout.add_instance_variable(:bro)
      @root = :field_access
      @string_input = <<HERE
self.bro
HERE
      @output = Register::RegisterValue
    check
    end

  end
end
