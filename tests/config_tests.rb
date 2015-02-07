# -*- coding: UTF-8 -*-

require "test/unit"
require "yop/config"
require_relative "test_utils"

class YopConfigTests < Test::Unit::TestCase
  def setup
    set_temporary_home
    Yop.init
    Yop.reload!
  end

  def teardown
    unset_temporary_home
  end

  # == #config == #

  def test_default_empty_config
    assert_equal({}, Yop.config)
  end

  def test_default_empty_config_with_key
    assert_nil Yop.config(:foo)
  end

  # == #config! == #

  def test_config_bang_set_value
    assert_nil Yop.config(:foo)
    Yop.config! :foo => 42
    assert_equal 42, Yop.config(:foo)
  end

  def test_config_bang_set_multiple_values
    assert_nil Yop.config(:foo)
    Yop.config! :foo => 42, :bar => "foo"
    assert_equal 42, Yop.config(:foo)
    assert_equal "foo", Yop.config(:bar)
  end

  # == #reload! == #

  def test_config_bang_set_value_preserved_after_reload
    assert_nil Yop.config(:foo)
    Yop.config! :foo => 42
    Yop.reload!
    assert_equal 42, Yop.config(:foo)

  end
end
