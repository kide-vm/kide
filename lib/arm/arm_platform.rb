require_relative "translator"
module Arm
  class ArmPlatform < Risc::Platform
    def translator
      Translator.new
    end
    def loaded_at
      0x10054
    end
    def padding
      0x11000 - loaded_at
    end
  end
end
