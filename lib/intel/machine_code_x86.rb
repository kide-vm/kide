module Intel

  ##
  # MachineCodeX86 is a concrete implementation of a machine to create
  # X86 assembly code on.
  #
  # To use this:
  #
  # a) you can instantiate an instance and use its register variables
  #    to build up machine code in the @stream variable and then use
  #    those bytes in any way that you see fit, or
  #
  #
  # == Using MachineCodeX86 for scripting
  #
  # This is the long hand way of writing assembly code, since you
  # always include a receiver with every command.
  #
  #     asm = Assembler.MachineCodeX86.new
  #
  # Once you have an assembler, you can access the registers and send
  # commands to them, eg:
  #
  #     asm.eax.mov 1
  #
  # As you send the commands, the @stream will build up containing the
  # X86 assembler bytes you can use. You can use memory addresses in
  # your assembler code with the #m method, eg:
  #
  #     asm.eax.m.mov 1
  #
  # Once you are finished, you simply send:
  #
  #     asm.stream
  #
  # This will return you the stream of bytes.
  #
  # == Labels & Jumps
  #
  # You can do labels and jump to them using two different label
  # commands. The first is #label, which places a label jump point
  # immediately on call, eg:
  #
  #         label = asm.label
  #         label.jmp
  #
  # The other is a future label that can be placed at some future
  # point in the program and jumped too
  #
  #         label = asm.future_label
  #         asm.eax.xor asm.eax
  #         label.jmp
  #         asm.eax.inc
  #         label.plant
  #
  # You #plant the future label where you want it to actually be and
  # past references to it will be updated. Future labels will always
  # use a dword jmp so that there's space to fill in the command if
  # the jmp ends up being far.

  class MachineCodeX86 
    
    attr_accessor :stream, :procedure, :bits, :cachedInstructions
    attr_reader :processors
    attr_writer :instructions

    def initialize
      self.procedure  = nil
      self.bits       = self.defaultBits
      self.processors = self.defaultProcessors
      self.stream     = []

      self.setupMachine
    end

    def inspect
      "#{self.class}#{stream.inspect}"
    end

    def processors= o
      @processors = o
      @cachedInstructions = nil
    end

    def supportsProcessor instructionProcessors
      # TODO: can still be improved. hashes, caching... something
      ! (processors & instructionProcessors).empty?
    end

    def instructions
      self.cachedInstructions ||= @instructions.select { |e|
        self.supportsProcessor e.processors
      }
      self.cachedInstructions
    end

    def method_missing msg, *args
      ok = Instruction.new( [msg, *args] , self).assemble
      return super unless ok
      ok
    end

    def label
      Label.new(self, stream.size)
    end

    def future_label
      FutureLabel.new self
    end

    def assemble instruction
      raise "no"
      #     aBlock on: MessageNotUnderstood do: [:ex |
      #         ex originator class = BlockClosure ifFalse: [ex pass].
      #         ex resume: (ex originator value m perform: ex parameter selector withArguments: ex parameter arguments)]</body>
    end
    
    # registers-general-32bit
    attr_accessor :eax, :ebx, :ebp, :esp, :edi, :esi, :ecx, :edx

    # registers-fpu
    attr_accessor :st0, :st1, :st2, :st3, :st4, :st5, :st6, :st7

    # registers-debug
    attr_accessor :dr0, :dr1, :dr2, :dr3, :dr6, :dr7

    # registers-segment
    attr_accessor :es, :ss, :cs, :gs, :fs, :ds

    # registers-test
    attr_accessor :tr3, :tr4, :tr5, :tr6, :tr7

    # registers-general-8bit
    attr_accessor :al, :ah, :bl, :bh, :cl, :ch, :dl, :dh

    # registers-general-16bit
    attr_accessor :ax, :bx, :cx, :dx, :sp, :bp, :si, :di

    # registers-control
    attr_accessor :cr0, :cr2, :cr3, :cr4

    # registers-mmx
    attr_accessor :mm0, :mm1, :mm2, :mm3, :mm4, :mm5, :mm6, :mm7

    def setupFPURegisters
      self.st0 = FPURegister.new self, 0
      self.st1 = FPURegister.new self, 1
      self.st2 = FPURegister.new self, 2
      self.st3 = FPURegister.new self, 3
      self.st4 = FPURegister.new self, 4
      self.st5 = FPURegister.new self, 5
      self.st6 = FPURegister.new self, 6
      self.st7 = FPURegister.new self, 7
    end

    def setupControlRegisters
      self.cr0 = ControlRegister.new self, 0
      self.cr2 = ControlRegister.new self, 2
      self.cr3 = ControlRegister.new self, 3
      self.cr4 = ControlRegister.new self, 4
    end

    def platform
      'i386'
    end

    def setupDebugRegisters
      self.dr0 = DebugRegister.new self, 0
      self.dr1 = DebugRegister.new self, 1
      self.dr2 = DebugRegister.new self, 2
      self.dr3 = DebugRegister.new self, 3
      self.dr6 = DebugRegister.new self, 6
      self.dr7 = DebugRegister.new self, 7
    end

    def defaultBits
      32
    end

    def setupSegmentRegisters
      self.es = SegmentRegister.new self, 0
      self.cs = SegmentRegister.new self, 1
      self.ss = SegmentRegister.new self, 2
      self.ds = SegmentRegister.new self, 3
      self.fs = SegmentRegister.new self, 4
      self.gs = SegmentRegister.new self, 5
    end

    def defaultProcessors
      %w(8086 186 286 386 486 PENT P6 CYRIX FPU MMX PRIV UNDOC)
    end

    def setupMachine
      self.instructions = Assembler.commands

      self.setup8BitRegisters
      self.setup16BitRegisters
      self.setup32BitRegisters
      self.setupSegmentRegisters
      self.setupControlRegisters
      self.setupTestRegisters
      self.setupDebugRegisters
      self.setupFPURegisters
      self.setupMMXRegisters
    end

    def setup8BitRegisters
      self.al = Register.new self, 0, 8
      self.cl = Register.new self, 1, 8
      self.dl = Register.new self, 2, 8
      self.bl = Register.new self, 3, 8
      self.ah = Register.new self, 4, 8
      self.ch = Register.new self, 5, 8
      self.dh = Register.new self, 6, 8
      self.bh = Register.new self, 7, 8
    end

    def setup16BitRegisters
      self.ax = Register.new self, 0, 16
      self.cx = Register.new self, 1, 16
      self.dx = Register.new self, 2, 16
      self.bx = Register.new self, 3, 16
      self.sp = Register.new self, 4, 16
      self.bp = Register.new self, 5, 16
      self.si = Register.new self, 6, 16
      self.di = Register.new self, 7, 16
    end

    def setupMMXRegisters
      self.mm0 = MMXRegister.new self, 0
      self.mm1 = MMXRegister.new self, 1
      self.mm2 = MMXRegister.new self, 2
      self.mm3 = MMXRegister.new self, 3
      self.mm4 = MMXRegister.new self, 4
      self.mm5 = MMXRegister.new self, 5
      self.mm6 = MMXRegister.new self, 6
      self.mm7 = MMXRegister.new self, 7
    end

    def setupTestRegisters
      self.tr3 = TestRegister.new self, 3
      self.tr4 = TestRegister.new self, 4
      self.tr5 = TestRegister.new self, 5
      self.tr6 = TestRegister.new self, 6
      self.tr7 = TestRegister.new self, 7
    end

    def setup32BitRegisters
      self.eax = Register.new self, 0, 32
      self.ecx = Register.new self, 1, 32
      self.edx = Register.new self, 2, 32
      self.ebx = Register.new self, 3, 32
      self.esp = Register.new self, 4, 32
      self.ebp = Register.new self, 5, 32
      self.esi = Register.new self, 6, 32
      self.edi = Register.new self, 7, 32
    end

    def arg n
      ebp + (n+3) * 4
    end

  end
end