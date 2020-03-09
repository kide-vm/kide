require_relative "../helper"

module Risc
  class TestRegisterValue1 < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @r0 = RegisterValue.new(:message , :Message).set_compiler(@compiler)
      @r1 = RegisterValue.new(:id_1234 , :Space).set_compiler(@compiler)
      @int = RegisterValue.new(:id_456 , :Integer).set_compiler(@compiler)
    end

    def test_resolves_index_ok
      assert_equal 6 , @r0.resolve_index(:caller)
    end
    def test_resolves_index_fail
      assert_raises {@r0.resolve_index(:something)}
    end
    def test_reduce_int
      ins = @int.reduce_int
      assert_equal RegisterValue , ins.class
      assert ins.compiler
      assert_equal SlotToReg , @compiler.current.class
      assert_equal Parfait::Integer.integer_index , @compiler.current.index
      assert_equal :"id_456.data_1" , ins.symbol
    end
    def test_get_new_left_0
      assert_equal RegisterValue , @r0.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_no_extra
      assert @r0.get_new_left(:caller , @compiler).extra.empty?
    end
    def test_get_new_left_0_reg
      assert_equal :"message.caller" , @r0.get_new_left(:caller , @compiler).symbol
    end
    def test_get_new_left_1
      assert_equal RegisterValue , @r0.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_1_reg
      assert_equal :"id_1234.classes" , @r1.get_new_left(:classes , @compiler).symbol
    end
    def test_get_left_uses_extra
      @r1 = RegisterValue.new(:message , :Space , type_arguments: @r0.type)
      # works with nil as compiler, because extra is used
      assert_equal :Message , @r1.get_new_left(:arguments , nil).type.class_name
    end
    def test_type_setting
      reg = @r0.known_type(:Integer)
      assert_equal Parfait::Type , reg.type.class
      assert_equal "Integer_Type" , reg.type.name
    end
  end
end
