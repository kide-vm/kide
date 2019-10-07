module SlotLanguage
  class SlotMaker
    attr_reader :leaps

    def initialize(leaps)
      case leaps
      when Array
        @leaps = leaps
      when nil
        raise "No leaps given"
      else
        @leaps = [leaps]
      end
    end

    def add_slot_name(name)
      @leaps << name
    end

    def slot_def(compiler)
      SlotMachine::SlotDefinition.new(:message , leaps)
    end
  end
end
