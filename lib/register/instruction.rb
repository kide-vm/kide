require_relative "code"
module Register

  # The register machine model is close to current hardware and has following instruction classes
  # - Memory
  # - Stack
  # - Logic
  # - Math
  # - Control/Compare
  # - Move
  # - Call
  
  # Instruction derives from Code, for the assembly api
  
  class Instruction < Code    
    def initialize  options
      @attributes = options
    end
    attr_reader :attributes
    attr_accessor :position
    def opcode
      @attributes[:opcode]
    end
    #abstract, only should be called from derived
    def to_s
      atts = @attributes.dup
      atts.delete(:opcode)
      atts.delete(:update_status)
      atts.delete(:condition_code) if atts[:condition_code] == :al
      atts.empty? ? "" : ", #{atts}"
    end
    # returns an array of registers (RegisterReferences) that this instruction uses.
    # ie for r1 = r2 + r3 
    # which in assembler is add r1 , r2 , r3
    # it would return [r2,r3]
    # for pushes the list may be longer, whereas for a jump empty
    def uses
      raise "abstract called for #{self.class}"
    end
    # returns an array of registers (RegisterReferences) that this instruction assigns to.
    # ie for r1 = r2 + r3 
    # which in assembler is add r1 , r2 , r3
    # it would return [r1]
    # for most instruction this is one, but comparisons and jumps 0 , and pop's as long as 16
    def assigns
      raise "abstract called for #{self.class}"
    end
    def method_missing name , *args , &block 
      return super unless (args.length <= 1) or block_given?
      set , attribute = name.to_s.split("set_")
      if set == ""
        @attributes[attribute.to_sym] = args[0] || 1
        return self 
      else
        return super
      end
      return @attributes[name.to_sym]
    end
  end
  
  class StackInstruction < Instruction
    def initialize first , options = {}
      @first = first
      super(options)
    end
    # when calling we place a dummy push/pop in the stream and calculate later what registers actually need saving 
    def set_registers regs
      @first = regs.collect{ |r| r.symbol }
    end
    def is_push?
      opcode == :push
    end
    def is_pop?
      !is_push?
    end
    def uses
      is_push? ? regs : []
    end
    def assigns
      is_pop? ? regs : []
    end
    def regs
      @first
    end
    def to_s
      "#{opcode} [#{@first.collect {|f| f.to_asm}.join(',') }] #{super}"
    end
  end
  class MemoryInstruction < Instruction
    def initialize result , left , right = nil , options = {}
      @result = result
      @left = left
      @right = right
      super(options)
    end
    def uses
      ret = [@left.register ]
      ret << @right.register unless @right.nil?
      ret
    end
    def assigns
      [@result.register]
    end
  end
  class LogicInstruction < Instruction
    #  result = left op right
    # 
    # Logic instruction are your basic operator implementation. But unlike the (normal) code we write
    #    these Instructions must have "place" to write their results. Ie when you write 4 + 5 in ruby
    #    the result is sort of up in the air, but with Instructions the result must be assigned 
    def initialize result , left , right , options = {}
      @result = result
      @left = left
      @right = right.is_a?(Fixnum) ? IntegerConstant.new(right) : right
      super(options)
    end
    attr_accessor :result , :left ,  :right
    def uses
      ret = []
      ret << @left.register if @left and not @left.is_a? Constant
      ret << @right.register if @right and not @right.is_a?(Constant)
      ret
    end
    def assigns
      [@result.register]
    end
    def to_s
      "#{opcode} #{result.to_asm} , #{left.to_asm} , #{right.to_asm} #{super}"
    end
  end
  class CompareInstruction < Instruction
    def initialize left , right , options  = {}
      @left = left
      @right = right.is_a?(Fixnum) ? IntegerConstant.new(right) : right
      super(options)
    end
    def uses
      ret = [@left.register ]
      ret << @right.register unless @right.is_a? Constant
      ret
    end
    def assigns
      []
    end
    def to_s
      "#{opcode} #{@left.to_asm} , #{@right.to_asm} #{super}"
    end
  end
  class MoveInstruction < Instruction
    def initialize to , from , options = {}
      @to = to
      @from = from.is_a?(Fixnum) ? IntegerConstant.new(from) : from
      raise "move must have from set #{inspect}" unless from
      super(options)
    end
    attr_accessor :to , :from
    def uses
      @from.is_a?(Constant) ? [] : [@from.register]
    end
    def assigns
      [@to.register]
    end
    def to_s
      "#{opcode} #{@to.to_asm} , #{@from.to_asm} #{super}"
    end
  end
  class CallInstruction < Instruction
    def initialize first , options  = {}
      @first = first
      super(options)
      opcode = @attributes[:opcode].to_s
      if opcode.length == 3 and opcode[0] == "b"
        @attributes[:condition_code] = opcode[1,2].to_sym
        @attributes[:opcode] = :b
      end
      if opcode.length == 6 and opcode[0] == "c"
        @attributes[:condition_code] = opcode[4,2].to_sym
        @attributes[:opcode] = :call
      end
    end
    def uses
      if opcode == :call
        @first.args.collect {|arg| arg.register }
      else
        []
      end
    end
    def assigns
      if opcode == :call
        [RegisterReference.new(RegisterMachine.instance.return_register)]
      else
        []
      end
    end
    def to_s
      "#{opcode} #{@first.to_asm} #{super}"
    end
  end
end
