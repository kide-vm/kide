module Risc
  # relies on @interpreter instance to be set up during setup
  module InterpreterHelpers

    def check_chain should
      should.each_with_index do |name , index|
        got = ticks(1)
        assert_equal got.class ,name , "Wrong class for #{index+1}, expect #{name} , got #{got}"
      end
    end

    def get_return
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
      @interpreter.get_register(:r0).return_value
    end

    def ticks( num )
      last = nil
      num.times do
        last = @interpreter.instruction
        @interpreter.tick
      end
      return last
    end

    def show_ticks
      classes = []
      tick = 1
      begin
        while true and (classes.length < 200)
          cl = ticks(1).class
          tick += 1
          classes << cl
          break if cl == NilClass
        end
      rescue => e
        puts "Error at tick #{tick}"
        puts e
        puts e.backtrace
      end
      str = classes.to_s.gsub("Risc::","")
      all = str.split(",").each_slice(5).collect {|line| "            " + line.join(",")}
      puts all.join(",\n")
      puts "length = #{classes.length}"
      exit(1)
    end
  end
end
