# -*- coding: UTF-8 -*-

require "fileutils"
require "tmpdir"

require "yop/extend/file"
require_relative "test_assets"

FU = FileUtils

class YopFileExtensionsTests < YopTestCase
  def setup
    @basepath = Dir.mktmpdir
    @pwd = Dir.pwd
    FU.cd @basepath
  end

  def teardown
    FU.cd @pwd
    FU.rm_rf @basepath
  end

  def test_not_binary_empty_file
    FU.touch "foo"
    assert_false File.binary? "foo"
  end

  def test_not_binary_directory
    FU.mkdir "foo"
    assert_false File.binary? "foo"
  end

  def test_not_binary_symlink
    FU.ln_s "bar", "foo"
    assert_false File.binary? "foo"
  end

  def test_not_binary_md_file
    File.write("foo.md", "# Foo\n\nsome text...")
    assert_false File.binary? "foo.md"
  end

  def test_binary_tgz_file
    File.binwrite("a.tgz", TGZ_CONTENT)
    assert_true File.binary? "a.tgz"
  end

end
