module Mom
  class Statements < Statement
    include Common::Statements

    def flatten( options = {} )
      flat = @statements.shift.flatten(options)
      while( nekst = @statements.shift )
        flat.append nekst.flatten(options)
      end
      flat
    end

    def initialize(arr)
      super(arr)
      arr.each {|s|
        raise "Not a Statement #{s}" unless s.is_a?( Statement) or s.is_a?(Instruction)
      }
    end
  end
end
