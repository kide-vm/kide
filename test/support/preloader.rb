module Preloader
  def builtin
    {
      "Integer.div4" => "def div4; X.div4;end",
      "Integer.ge" => "def >; X.comparison(:>);end",
      "Object.get" => "def get_internal_word(at); X.get_internal_word;end",
    }
  end
  def get_preload(preload)
    return "" unless preload
    preload.split(";").collect do |loads|
      raise "no preload #{loads}" unless builtin[loads]
      clazz , meth = loads.split(".")
      "class #{clazz}; #{builtin[loads]};end;"
    end.join
  end
  def preload
    get_preload(@preload)
  end
end
