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

  def show_ticks
    classes = []
    error = nil
    tick = 1
    begin
      while true and (classes.length < 100)
        cl = ticks(1).class
        tick += 1
        classes << cl
        break if cl == NilClass
      end
    rescue => e
      puts "Error at tick #{tick}"
      puts e
    end
    classes = classes.collect {|c| '"' + c.name.sub("Register::","")  + '",' }
    classes.each_slice(5).each do |line|
      puts "     " + line.join
    end
    exit(1)
  end
end
