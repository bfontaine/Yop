# -*- coding: UTF-8 -*-

require "yop/bootstrap"
require_relative "test_utils"

class YopBootstrapTests < YopTestCase

  # == #bootstrap == #

  def test_bootstrap_raise_if_template_doesnt_exist
    assert_raise(NonExistentTemplate) do
      Yop.bootstrap("dont-exist", Yop.home)
    end
  end
end
