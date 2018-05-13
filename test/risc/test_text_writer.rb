require_relative "../helper"

module Risc
  class TestTextWriter #< MiniTest::Test

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
  end
  class TestTextWriterPositions < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
      @machine.position_all
      @text_writer = TextWriter.new(@machine)
    end
    def test_write_all
      assert @text_writer.write_as_string
    end
    def test_sorted_class
      assert_equal Array ,  @text_writer.sorted_objects.class
    end
    def test_sorted_positions1
      sorted_objects = @text_writer.sorted_objects
      sorted_objects.each_slice(2) do |l,r|
        assert Position.get(l).at < Position.get(r).at , "#{Position.get(l)} < #{Position.get(r)} , #{l.class}, #{r.class}"
      end
    end
    def test_sorted_positions2
      sorted_objects = @text_writer.sorted_objects
      sorted_objects.shift
      sorted_objects.each_slice(2) do |l,r|
        next unless l
        next unless r
        assert Position.get(l).at < Position.get(r).at , "#{Position.get(l)} < #{Position.get(r)} , #{l.class}, #{r.class}"
      end
    end
  end
end
