require 'intel/register'
require 'intel/address'

module Intel

  ##
  # Assembler parses the NASM documentation and creates Command
  # objects for it

  class Assembler
    attr_accessor :commands , :raw_commands

    def self.nasm_fixes
      # TODO: extend parser to split /[,:]/ and remove some of these
      '
       CALL imm,imm16 ; o16 9A iw iw         [8086]
       CALL imm,imm32 ; o32 9A id iw         [386]
       CALLFAR mem16  ; o16 FF /3            [8086]
       CALLFAR mem32  ; o32 FF /3            [386]

       Jcc imm        ; 0F 80+cc rw/rd       [386]

       JMP imm,imm16  ; o16 EA iw iw         [8086]
       JMP imm,imm32  ; o32 EA id iw         [386]
       JMP imm16      ; E9 rw/rd             [8086]
       JMP imm32      ; E9 rw/rd             [8086]
       JMP imm8       ; EB rb                [8086]
       JMPFAR mem16   ; o16 FF /5            [8086]
       JMPFAR mem32   ; o32 FF /5            [386]

       FADDTO fpureg  ; DC C0+r              [8086,FPU]
       FDIVTO fpureg  ; DC F8+r              [8086,FPU]
       FDIVRTO fpureg ; DC F0+r              [8086,FPU]
       FMULTO fpureg  ; DC C8+r              [8086,FPU]
       FSUBTO fpureg  ; DC E8+r              [8086,FPU]
       FSUBRTO fpureg ; DC E0+r              [8086,FPU]

       CMP r/m16,imm8 ; o16 83 /7 ib         [8086]
       CMP r/m32,imm8 ; o32 83 /7 ib         [386]
       SAR r/m16,1    ; o16 D1 /7            [8086]
       SAR r/m32,1    ; o32 D1 /7            [386]
      '
    end

    def self.nasm
      File.read(__FILE__.sub(".rb",".txt"))
    end

    @@default = nil

    def self.default
      @@default ||= self.new.parse
    end

    def self.commands
      self.default.commands
    end

    def initialize
      self.commands = []
      self.raw_commands = []
    end

    def expand_parameters command
      command.parameters.each_with_index do |parameter, index|
        if String === parameter && parameter =~ /^r\/m(\d+)/ then
          bits = $1.to_i
          newCommand = command.dup
          commands << newCommand
          case bits
          when 8, 16, 32 then
            command.parameters[index]    = MemoryRegister.new bits
            newCommand.parameters[index] = Address.new false, bits
          when 64 then
            command.parameters[index]    = MMXRegister.new nil,nil,bits
            newCommand.parameters[index] = Address.new false, bits
          end
        end
      end
    end

    def add_conditional_commands prototype
      prototype.opcode = prototype.opcode[0..-3]

      self.conditionals.each do |conditional, value|
        command = prototype.dup
        command.opcode += conditional

        command.opcodes.each_with_index do |op, index|
          command.opcodes[index] = ($1.hex+value).to_s(16) if op =~ /(.*)\+cc$/
        end

        self.add_command command
      end
    end

    def process_line line # TODO: remove
      return if line.empty?
      return unless line =~ /^[A-Z].+;.*\[/

      self.parse_command line
    end
    
    def add_raw_command raw
      @raw_commands << raw
    end

    def add_command command
      return self.add_conditional_commands(command) if command.opcode =~ /cc$/i
      self.commands << command
      self.expand_parameters command
    end

    def conditionals
      @conditionals ||= {
        'O'   =>  0, 'NO' =>  1, 'B'  =>  2, 'C'   =>  2, 'NAE' =>  2,
        'AE'  =>  3, 'NB' =>  3, 'NC' =>  3, 'E'   =>  4, 'Z'   =>  4,
        'NE'  =>  5, 'NZ' =>  5, 'BE' =>  6, 'NA'  =>  6, 'A'   =>  7,
        'NBE' =>  7, 'S'  =>  8, 'NS' =>  9, 'P'   => 10, 'PE'  => 10,
        'NP'  => 11, 'PO' => 11, 'L'  => 12, 'NGE' => 12, 'GE'  => 13,
        'NL'  => 13, 'LE' => 14, 'NG' => 14, 'G'   => 15, 'NLE' => 15,
      }
    end

    def parse_command line
      if line =~ /^(\w+)\s+([^;]*)\s+;\s+([^\[]+)\s+\[([\w,]+)\]/ then
        name, params, ops, procs = $1, $2, $3, $4
        command            = Command.new(name,  ops.split , procs.split(/,/) )
        command.initialize_parameters params.strip
        self.add_raw_command command
      else
        raise "unparsed: #{line}"
      end
    end

    def parse
      (self.class.nasm + self.class.nasm_fixes).each_line do |line|
        self.process_line line.strip.sub(/^# /, '')
      end
      @raw_commands.each do |command|
        add_command command
      end
      self
    end
  end

end