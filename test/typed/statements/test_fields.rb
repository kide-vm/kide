require_relative 'helper'


module Register
  class TestFieldStatement < MiniTest::Test
    include Statements

    def test_field_frame
      @input =         s(:statements,
          s(:field_def, :Message,
            s(:name, :m)),
          s(:return,
            s(:field_access,
              s(:receiver,
                s(:name, :m)),
              s(:field,
                s(:name, :name)))))

      @expect =  [Label, GetSlot, GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
      check
    end

    def test_field_arg
      clean_compile s(:statements,
                      s(:class, :Space,
                        s(:derives, nil),
                        s(:statements,
                          s(:function, :Integer,
                            s(:name, :get_name),
                            s(:parameters,
                              s(:parameter, :Message, :main)),
                            s(:statements,
                              s(:return,
                                s(:field_access,
                                  s(:receiver,
                                    s(:name, :main)),
                                  s(:field,
                                    s(:name, :name)))))))))

      @input =  s(:statements,
                  s(:field_def, :Message,
                    s(:name, :m)),
                  s(:return,
                    s(:call,
                      s(:name, :get_name),
                      s(:arguments,
                        s(:name, :m)))))

      @expect =  [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
                 SetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, RegisterTransfer ,
                 FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, SetSlot, Label ,
                 FunctionReturn]
      check
    end

    def test_self_field
      @input =         s(:statements,
                  s(:field_def, :Type,
                    s(:name, :l),
                    s(:field_access,
                      s(:receiver,
                        s(:name, :self)),
                      s(:field,
                        s(:name, :type)))),
                  s(:return,
                    s(:int, 1)))

      @expect =  [Label, GetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot ,
                  Label, FunctionReturn]
      check
    end

    def test_message_field
      @input =         s(:statements,
                  s(:field_def, :Word,
                    s(:name, :name),
                    s(:field_access,
                      s(:receiver,
                        s(:name, :message)),
                      s(:field,
                        s(:name, :name)))),
                  s(:return,
                    s(:name, :name)))

      @expect =   [Label, RegisterTransfer, GetSlot, GetSlot, SetSlot, GetSlot, GetSlot ,
               SetSlot, Label, FunctionReturn]
      check
    end
  end
end
