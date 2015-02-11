# -*- coding: UTF-8 -*-

require "yop/templates"
require "yop/exceptions"
require_relative "test_utils"

class YopTemplatesTests < YopTestCase
  def setup
    super
    Yop.init
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

    assert_directory dest
    assert_equal [], ls_Ra(dest)
  end

  def test_apply_empty_template_on_existing_dir
    mkdir "templates/foo"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal [], ls_Ra(dest)
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
    assert_equal [], ls_Ra(dest)
  end

  def test_apply_empty_template_ignore_git_dir
    mkdir_p "templates/foo/.git"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal [], ls_Ra(dest)
  end

  def test_apply_dirs_only
    mkdir_p "templates/foo/bar"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/bar"
  end

  def test_apply_dirs_with_empty_file
    mkdir_p "templates/foo/bar"
    touch "templates/foo/barqux"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/bar"
    assert_true File.file?("#{dest}/barqux")
  end

  # special files

  def test_apply_symlink
    mkdir_p "templates/foo/a"
    FileUtils.cd "#{Yop.home}/templates/foo" do
      FileUtils.ln_s "a", "b"
    end
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/a"
    assert_true File.symlink?("#{dest}/b")
  end

  def test_apply_fifo
    mkdir_p "templates/foo"
    mkfifo "templates/foo/pipe"
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_raise(UnsupportedFileType) { t.apply dest }
  end

  # permissions

  def test_apply_executable_file
    mkdir_p "templates/foo"
    touch "templates/foo/exe"
    chmod 0744, "templates/foo/exe"
    assert_equal 0100744, File.new("#{Yop.home}/templates/foo/exe").stat.mode
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal 0100744, File.new("#{dest}/exe").stat.mode
  end

  def test_apply_symlink_dont_fail_if_cannot_set_permissions
    unimplement_lchmod!
    mkdir_p "templates/foo"
    touch "templates/foo/a"
    FileUtils.cd "#{Yop.home}/templates/foo" do
      FileUtils.ln_s "a", "b"
    end
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
  end

  def test_apply_symlink_set_permissions_if_possible
    implement_lchmod!
    mkdir_p "templates/foo"
    touch "templates/foo/a"
    FileUtils.cd "#{Yop.home}/templates/foo" do
      FileUtils.ln_s "a", "b"
    end
    t = Yop.get_template("foo")
    mkdir_p "tmp/test-foo"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_equal 2, @lchmod_args.length
    assert_equal "b", @lchmod_args[-1]
  end

  # TODO test dir permissions

  # placeholders in paths

  def test_apply_dir_with_variable_placeholder_string
    mkdir_p "templates/foo/{(SOME_VAR)}"
    t = Yop.get_template("foo")
    t["SOME_VAR"] = "barqux"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/barqux"
    assert_not_directory "#{dest}/{(SOME_VAR)}"
  end

  def test_apply_dir_with_variable_placeholder_symbol
    mkdir_p "templates/foo/{(SOME_VAR)}"
    t = Yop.get_template("foo")
    t[:SOME_VAR] = "barqux"
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/barqux"
    assert_not_directory "#{dest}/{(SOME_VAR)}"
  end

  def test_apply_dir_with_variable_placeholder_symbol_from_config
    capture_output!
    set_input "not-barqux"

    mkdir_p "templates/foo/{(SOME_VAR)}"
    Yop.config! :vars => {:SOME_VAR => "barqux"}
    t = Yop.get_template("foo")
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/barqux"
    assert_not_directory "#{dest}/not-barqux"
    assert_not_directory "#{dest}/{(SOME_VAR)}"
  end

  # placeholders in files

  def test_apply_file_with_variable_placeholders_in_content
    mkdir_p "templates/foo"
    name = "afoo"
    author = "abar"
    File.open("#{Yop.home}/templates/foo/README", "w") do |f|
      f.write <<-EOS
# {(NAME)}

This is the project {(NAME)} by {(AUTHOR)}.
EOS
    end
    t = Yop.get_template("foo")
    t["NAME"] = name
    t["AUTHOR"] = author
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    expected = <<-EOS
# #{name}

This is the project #{name} by #{author}.
EOS
    assert_true File.file?("#{dest}/README")
    assert_equal expected, File.read("#{dest}/README")
  end

  # UI variables

  def test_apply_dir_with_var_in_path_values_from_terminal
    capture_output!
    set_input "barqux"
    mkdir_p "templates/foo/{(SOME_VAR)}"
    t = Yop.get_template("foo")
    dest = "#{Yop.home}/tmp/test-foo"
    assert_nothing_raised { t.apply dest }
    assert_directory "#{dest}/barqux"
    assert_not_directory "#{dest}/{(SOME_VAR)}"
    assert_include read_output, "SOME_VAR"
  end

end
