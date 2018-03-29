require_relative "../helper"

module Risc
  class TestTextWriter < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def test_init
      @text_writer = TextWriter.new(@machine)
    end
    def test_write_fails
      @text_writer = TextWriter.new(@machine)
      assert_raises{ @text_writer.write_as_string} #must translate first
    end
    def test_write_space
      assert @machine.position_all
      @text_writer = TextWriter.new(@machine)
      assert @text_writer.write_as_string
    end
  end
end
