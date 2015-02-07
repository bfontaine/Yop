# -*- coding: UTF-8 -*-

require "test/unit"
require "yop/bootstrap"
require_relative "test_utils"

class YopBootstrapTests < Test::Unit::TestCase
  def setup
    set_temporary_home
    Yop.init
  end

  def teardown
    unset_temporary_home
  end

  # == #bootstrap == #

  def test_bootstrap_raise_if_template_doesnt_exist
    assert_raise(NonExistentTemplate) do
      Yop.bootstrap("dont-exist", Yop.home)
    end
  end
end
