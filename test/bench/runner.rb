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
    #puts "no    per   var"

    puts "#{@n}    #{(@mean*1000).truncate(1)}   #{((@variance / @n)*100).truncate(2)}"
  end
end
class Runner
  def initialize
    @stats = Stats.new
    @cmd = ARGV.join(" ")
  end
  def run
    while true
      once
    end
  end

  def once
    GC.disable
    took = Benchmark.measure { %x(#{@cmd} > /dev/null)}.real
    GC.enable
    @stats.add took
    @stats.show
  end
end

Runner.new.run
