# -*- coding: UTF-8 -*-

require "test/unit"
require "yop/home"
require_relative "test_utils"

class YopHomeTests < Test::Unit::TestCase
  def setup
    set_temporary_home
  end

  def teardown
    unset_temporary_home
  end

  # == #home == #

  def test_home_no_subcomponent
    assert_equal @basepath, Yop.home
  end

  def test_home_subcomponent
    assert_equal "#{@basepath}/foo/bar", Yop.home("foo/bar")
  end

  # == #init == #

  def test_init_create_dir
    assert_false File.directory?(@basepath)
    Yop.init
    assert_true File.directory?(@basepath)
  end

  def test_init_create_template_dir
    Yop.init
    assert_true File.directory?("#{@basepath}/templates")
  end

  def test_init_create_config_file
    Yop.init
    assert_true File.file?("#{@basepath}/config.yml")
  end
end
