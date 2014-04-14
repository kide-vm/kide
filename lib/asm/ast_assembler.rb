module Asm
  class AstAssembler
    def initialize(asm_arch)
      @asm_arch = asm_arch

      @symbols = {}
      @inst_label_context = {}

      @asm = Asm::Assembler.new
    end
  
    def assembler
      @asm
    end

    def load_ast(ast)
      label_breadcrumb = []
      ast.children.each do |cmd|
        if (cmd.is_a?(Asm::Parser::LabelNode))
          m = /^\/+/.match(cmd.name)
          count = m ? m[0].length : 0
          label_breadcrumb = label_breadcrumb[0,count]
          label_breadcrumb << cmd.name[count..-1]
          @asm.add_object object_for_label(label_breadcrumb.join('/'))
        elsif (cmd.is_a?(Asm::Parser::InstructionNode))
          inst = @asm_arch::Instruction.new(cmd, self)
          @asm.add_object inst
          @inst_label_context[inst] = label_breadcrumb
        elsif (cmd.is_a?(Asm::Parser::DirectiveNode))
          if (cmd.name == 'global')
            symbol_for_label(cmd.value)[:linkage] = Elf::Constants::STB_GLOBAL
          elsif (cmd.name == 'extern')
            object_for_label(cmd.value).extern!
          elsif (cmd.name == 'hexdata')
            bytes = cmd.value.strip.split(/\s+/).map do |hex|
              hex.to_i(16)
            end.pack('C*')
            @asm.add_object Asm::DataObject.new(bytes)
          elsif (cmd.name == "asciz")
            str = eval(cmd.value) + "\x00"
            @asm.add_object Asm::DataObject.new(str)
          elsif (defined?(Asm::Arm) and cmd.name == 'addrtable')
            @asm.add_object Asm::Arm::AddrTableObject.new
          else
            raise Asm::AssemblyError.new('unknown directive', cmd)
          end
        end
      end
    end

    # instruction is user for label context
    def symbol_for_label(name, instruction=nil)
      if (instruction)
        context = @inst_label_context[instruction]
        m = /^(\/*)(.+)/.match(name)
        breadcrumb = context[0,m[1].length]
        breadcrumb << m[2]
        qual_name = breadcrumb.join('/')
      else
        qual_name = name
      end
    
      if (not @symbols[qual_name])
        @symbols[name] = {:label => Asm::LabelObject.new, :linkage => Elf::Constants::STB_LOCAL, :name => qual_name}
      end
      @symbols[qual_name]
    end

    def object_for_label(name, instruction=nil)
      symbol_for_label(name, instruction)[:label]
    end

    def assemble(io)
      @asm.assemble io
    end

    def symbols
      @symbols.values
    end

    def relocations
      @asm.relocations
    end
  end
end