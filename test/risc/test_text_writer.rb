require_relative "../helper"

module Risc
  class TestTextWriter < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(:arm)
    end
    def test_init
      @text_writer = TextWriter.new(@linker)
    end
    def test_write_fails
      @text_writer = TextWriter.new(@linker)
      assert_raises{ @text_writer.write_as_string} #must translate first
    end
  end
  class TestTextWriterPositions < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @linker = Mom::MomCompiler.new.translate(:arm)
      @linker.position_all
      @linker.create_binary
      @text_writer = TextWriter.new(@linker)
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
        next unless r
        next if l.is_a?(Label) or r.is_a?(Label)
        assert Position.get(l).at < Position.get(r).at , "#{Position.get(l)} < #{Position.get(r)} , #{l.object_id.to_s(16)}, #{r.object_id.to_s(16)}"
      end
    end
    def test_sorted_positions2
      sorted_objects = @text_writer.sorted_objects
      sorted_objects.shift
      sorted_objects.each_slice(2) do |l,r|
        next unless r
        next if l.is_a?(Label) or r.is_a?(Label)
        assert Position.get(l).at < Position.get(r).at , "#{Position.get(l)} < #{Position.get(r)} , #{l.object_id.to_s(16)}, #{r.object_id.to_s(16)}"
      end
    end
  end
end
