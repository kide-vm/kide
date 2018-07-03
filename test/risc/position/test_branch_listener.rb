require_relative "helper"
require 'minitest/mock'

module Risc
  class TestBranchListenerBooted < MiniTest::Test
    def setup
      Parfait.boot!
      @binary = Parfait::BinaryCode.new(1)
      @bin_pos = CodeListener.init(@binary,:interpreter).set(0)
      @label = Label.new("HI","ho" , FakeAddress.new(2))
      @branch = DummyBranch.new( "Dummy" , @label )
      @branch.insert @label
      InstructionListener.init(@branch , @binary)
      @position = Position.get(@label)
    end
    def test_init_add_listener
      assert_equal BranchListener , @position.event_table.values.first.last.class
    end
    def test_set
      Position.get(@branch).set(12)
      assert_equal 16 , Position.get(@label).at
    end
    def test_set_fires
      Position.get(@label).set(20)
      assert @branch.precheck_called
    end
  end
  class TestBranchListenerPositioned #< MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.translate(:interpreter)
      @machine.position_all
    end
  end
end
