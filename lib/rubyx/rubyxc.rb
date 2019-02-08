require "thor"
require "rubyx"

class RubyXC < Thor
  desc "compile FILE" , "Compile given FILE to binary"
  long_desc <<-LONGDESC
      Very basic cli to compile ruby programs.
      Currently only compile command supported without option.

      Output will be elf object file of the same name, with .o, in root directory.

      Note: Because of Bug #13, you need to run "ld -N file.o" on the file, before
      executing it. This can be done on a mac by installing a cross linker
      (brew install arm-linux-gnueabihf-binutils), or on the target arm machine.
    LONGDESC

  def compile(file)
    begin
      ruby = File.read(file)
    rescue
      fail MalformattedArgumentError , "No such file #{file}"
    end
    puts "compiling #{file}"

    linker = ::RubyX::RubyXCompiler.new({}).ruby_to_binary( ruby , :arm )
    writer = Elf::ObjectWriter.new(linker)

    outfile = file.split("/").last.gsub(".rb" , ".o")
    writer.save outfile

    return outfile
  end
end
