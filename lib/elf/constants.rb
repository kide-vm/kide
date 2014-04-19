module Elf
  module Constants
    ET_NONE = 0
    ET_REL = 1
    ET_EXEC = 2
    ET_DYN = 3
    ET_CORE = 4

    EM_NONE = 0
    EM_M32 = 1
    EM_SPARC = 2
    EM_386 = 3
    EM_68K = 4
    EM_88K = 5
    EM_860 = 7
    EM_MIPS = 8
    EM_ARM = 40
  
    EV_NONE = 0
    EV_CURRENT = 1

    ELFCLASSNONE = 0
    ELFCLASS32 = 1
    ELFCLASS64 = 2

    Elf::DATANONE = 0
    Elf::DATA2LSB = 1
    Elf::DATA2MSB = 2

    SHT_NULL = 0
    SHT_PROGBITS = 1
    SHT_SYMTAB = 2
    SHT_STRTAB = 3
    SHT_RELA = 4
    SHT_HASH = 5
    SHT_DYNAMIC = 6
    SHT_NOTE = 7
    SHT_NOBITS = 8
    SHT_REL = 9
    SHT_SHLIB = 10
    SHT_DYNSYM = 11

    SHF_WRITE = 0x1
    SHF_ALLOC = 0x2
    SHF_EXECINSTR = 0x4

    STB_LOCAL = 0
    STB_GLOBAL = 1
    STB_WEAK = 2

    ABI_SYSTEMV = 0
    ABI_ARM = 0x61

    ARM_INFLOOP = "\x08\xf0\x4f\xe2"

    TARGET_ARM = [ELFCLASS32, Elf::DATA2LSB, ABI_ARM, EM_ARM]
    TARGET_X86 = [ELFCLASS32, Elf::DATA2LSB, ABI_SYSTEMV, EM_386]
  end
end