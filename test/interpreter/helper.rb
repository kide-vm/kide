require_relative "../helper"
require "interpreter/interpreter"

module Ticker
  def ticks num
    last = nil
    num.times do
      last = @interpreter.instruction
      @interpreter.tick
    end
    return last
  end
end
