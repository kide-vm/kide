module Risc
  # relies on @interpreter instance to be set up during setup
  module InterpreterHelpers

    # check the given array of instructions is what the interpreter actually does
    # possible second argument ignores the given amount, usually up until main
    def check_chain( should , start_at = 0 )
      ticks( start_at ) if start_at > 0
      should.each_with_index do |name , index|
        got = ticks(1)
        assert_equal got.class ,name , "Wrong class for #{index + 1 - start_at}, expect #{name} , got #{got}"
      end
    end
    # check the main only, ignoring the __init instructions
    def check_main_chain( should )
      check_chain( should , main_at)
    end

    # how many instruction up until the main starts, ie
    # ticks(main_at) will be the label for main
    def main_at
      26
    end

    def get_return
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
      @interpreter.get_register(:r0).return_value
    end

    # do as many as given ticks in the main, ie main_at more
    def main_ticks(num)
      ticks( main_at + num)
    end

    # do a certain number of steps in the interpreter and return the last executed instruction
    def ticks( num )
      last = nil
      num.times do
        last = @interpreter.instruction
        @interpreter.tick
      end
      return last
    end

    # collect the classes of all executed istructions
    def all_classes
      classes = []
      tick = 1
      begin
        while true and (classes.length < 300)
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
      classes
    end

    # for chaning the tests quickly output all instructions that are executed
    def show_ticks
      classes = all_classes
      output_classes(classes)
    end
    # show all instructions of the main only
    def show_main_ticks
      classes = all_classes
      classes = classes.slice(main_at , 1000)
      output_classes(classes)
    end

    def output_classes(classes)
      str = classes.to_s.gsub("Risc::","")
      all = str.split(",").each_slice(5).collect {|line| "            " + line.join(",")}
      puts all.join(",\n")
      puts "length = #{classes.length}"
      exit(1)
    end
  end
end
