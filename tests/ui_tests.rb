# -*- coding: UTF-8 -*-

require "yop/ui"
require "yop/exceptions"
require_relative "test_utils"

class YopUITests < YopTestCase
  def setup
    super
    @term = Yop::TerminalUI.new
  end

  def test_base_ui_get_variable_raise_exception
    ui = Yop::UI.new

    assert_raise(UndefinedTemplateVariable) { ui.get_var "" }
    assert_raise(UndefinedTemplateVariable) { ui.get_var "foo" }
    assert_raise(UndefinedTemplateVariable) { ui.get_var :foo }
  end

  def test_term_ui_print_var_name
    capture_output!
    set_input "value"

    assert_nothing_raised { @term.get_var "bar" }
    assert_equal "bar = ", read_output
  end

  def test_term_ui_raise_if_cant_read
    capture_output!
    set_input ""

    assert_raise(UndefinedTemplateVariable) { @term.get_var "foo" }
  end

  def test_term_ui_chomp_value
    capture_output!
    value = "something"
    set_input "#{value}\n"
    assert_equal value, @term.get_var("foo")
  end
end
