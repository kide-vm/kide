module Preloader
  def builtin
    {
      "Object.get" => "def get_internal_word(at); X.get_internal_word;end",
      "Object.missing" => "def method_missing(at); X.method_missing;end",
      "Object.init" => "def __init__(at); X.init;end",
      "Object.exit" => "def exit; X.exit;end",
      "Integer.div4" => "def div4; X.div4;end",
      "Integer.div10" => "def div10; X.div10;end",
      "Integer.gt" => "def >; X.comparison(:>);end",
      "Integer.lt" => "def <; X.comparison(:<);end",
      "Integer.ge" => "def >=; X.comparison(:>=);end",
      "Integer.le" => "def <=; X.comparison(:<=);end",
      "Integer.plus" => "def +; X.int_operator(:+);end",
      "Integer.minus" => "def -; X.int_operator(:-);end",
      "Integer.mul" => "def *; X.int_operator(:*);end",
      "Integer.and" => "def &; X.int_operator(:&);end",
      "Integer.or" => "def |; X.int_operator(:|);end",
      "Integer.ls" => "def <<; X.int_operator(:<<);end",
      "Integer.rs" => "def >>; X.int_operator(:>>);end",
      "Word.put" => "def putstring(at); X.putstring;end",
      "Word.set" => "def set_internal_byte(at, val); X.set_internal_byte;end",
      "Word.get" => "def get_internal_byte(at); X.get_internal_byte;end",
      "Space.main" => "def main(args);return;end",
    }
  end
  def get_preload(preload)
    return "" unless preload
    preload = builtin.keys.join(";") if(preload == "all" )
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
