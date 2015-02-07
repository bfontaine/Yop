# -*- coding: UTF-8 -*-

require "test/unit"
require "yop/templates"
require "yop/exceptions"
require_relative "test_utils"

class YopTemplatesTests < Test::Unit::TestCase
  def setup
    set_temporary_home
    Yop.init
  end

  def teardown
    unset_temporary_home
  end

  # == #templates == #

  def test_empty_templates_list
    assert_equal [], Yop.templates
  end

  def test_templates_list
    mkdir "templates/foo"
    mkdir "templates/bar"

    lst = %w[bar foo].map { |t| "#{Yop.home("templates")}/#{t}" }

    assert_equal lst, Yop.templates.sort
  end

  # == #get_template == #

  def test_get_template_raise_if_doesnt_exist
    assert_raise(NonExistentTemplate) do
      Yop.get_template("dont-exist")
    end
  end

  def test_get_template_object
    mkdir "templates/foo"

    assert_instance_of Yop::Template, Yop.get_template("foo")
  end

  # == Template#apply == #

  def test_apply_empty_template_on_unexisting_dir
    mkdir "templates/foo"
    t = Yop.get_template("foo")
    mkdir "tmp"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }

    assert_true File.directory?(dest)
    assert_equal [], Dir["#{dest}/**/*", "#{dest}/**/.*"]
  end

  def test_apply_empty_template_on_existing_dir
    mkdir "templates/foo"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal [], Dir["#{dest}/**/*", "#{dest}/**/.*"]
  end

  def test_apply_empty_template_ignore_temporary_files
    root = "templates/foo"
    mkdir root
    touch "#{root}/foo~"
    touch "#{root}/.bar.swp"
    touch "#{root}/.qux.swo"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal [], Dir["#{dest}/**/*", "#{dest}/**/.*"]
  end

  def test_apply_empty_template_ignore_git_dir
    mkdir_p "templates/foo/.git"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal [], Dir["#{dest}/**/*", "#{dest}/**/.*"]
  end
end
