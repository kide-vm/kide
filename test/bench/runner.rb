require "benchmark"
class Stats

  def initialize
    @n = 0
    @mean = 0.0
    @variance = 0.0
  end
  attr_reader :n , :mean ,  :variance

  def add(x)
    @n = @n + 1
    delta = x - @mean
    @mean = @mean + delta/@n
    @variance = @variance + delta*(x - @mean)
  end
  def show
    puts "no    per   var"
    puts "#{@n}    #{@mean}   #{@variance}"
  end
end
class Runner
  def initialize num = 20
    @stats = Stats.new
    @cmd = ARGV[0]
    @interations = num
  end
  def run
    @interations.times { once }
    @stats.show
  end

  def once
    GC.disable
    took = Benchmark.measure { %x("#{@cmd}")}.real
    GC.enable
    @stats.add took
  end
end

Runner.new.run
