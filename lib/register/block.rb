module Register

  # Think flowcharts: blocks are the boxes. The smallest unit of linear code

  # Blocks must end in control instructions (jump/call/return).
  # And the only valid argument for a jump is a Block

  # Blocks form a graph, which is managed by the method

  class Block

    def initialize(name , method )
      super()
      @method = method
      raise "Method is not Method, but #{method.class}" unless method == :__init__ or method.is_a?(Parfait::Method)
      @name = name.to_sym
      @codes = []
    end

    attr_reader :name , :codes , :method , :position

    def add_code kode
      @codes << kode
      self
    end

    # replace a code with an array of new codes. This is what happens in passes all the time
    def replace code , new_codes
      index = @codes.index code
      raise "Code not found #{code} in #{self}" unless index
      @codes.delete_at(index)
      if( new_codes.is_a? Array)
        new_codes.reverse.each {|c| @codes.insert(index , c)}
      else
        @codes.insert(index , new_codes)
      end
    end

    # position is what another block uses to jump to. this is determined by the assembler
    # the assembler allso assembles and assumes a linear instruction sequence
    # Note: this will have to change for plocks and maybe anyway.
    def set_position at
      @position = at
      @codes.each do |code|
        begin
          code.set_position( at)
        rescue => e
          puts "BLOCK #{self.to_s[0..5000]}"
          raise e
        end
        raise code.inspect unless code.byte_length
        at += code.byte_length
      end
    end

    def byte_length
      @codes.inject(0){|count , instruction| count += instruction.byte_length }
    end

  end
end
