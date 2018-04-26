require_relative "../helper"

module Parfait
  class ParfaitTest < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
      @space = Parfait.object_space
    end
  end
end
