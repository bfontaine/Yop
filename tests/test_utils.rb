# -*- coding: UTF-8 -*-

require "fileutils"
require "tmpdir"
require "stringio"

require "yop"

# An enhanced TestCase class for Yop
class YopTestCase < Test::Unit::TestCase
  def setup
    @old_basepath = Yop.basepath
    @basepath = Yop.basepath = "#{Dir.mktmpdir}/.yop"

    @_stdin = $stdin
    @_stdout = $stdout
    @_stderr = $stderr

    @pwd = Dir.pwd
  end

  def teardown
    Yop.basepath = @old_basepath
    FileUtils.rm_rf @basepath

    $stdin = @_stdin
    $stdout = @_stdout
    $stderr = @_stderr

    FileUtils.cd @pwd
  end

  def capture_output!
    $stdout = StringIO.new
  end

  def set_input(text)
    $stdin = StringIO.new
    $stdin.write text
    $stdin.rewind
  end

  def read_output
    $stdout.rewind
    $stdout.read
  end

  def assert_directory path
    assert_true File.directory?(path)
  end

  def assert_not_directory path
    assert_false File.directory?(path)
  end

  # ls -R -a
  def ls_Ra path
    Dir["#{path}/**/*", "#{path}/**/.*"].reject do |d|
      # reject . & .. (for Ruby 1.9)
      d =~ %r(/\.\.?$) && File.directory?(d)
    end
  end

  # proxy FileUtils methods by prepending a @basepath
  [:mkdir, :mkdir_p, :touch].each do |name|
    define_method(name) do |path|
      FileUtils.send(name, "#{@basepath}/#{path}")
    end
  end

  def mkfifo path
    system "mkfifo", "#{@basepath}/#{path}"
  end

  def system(*args)
    ret = Kernel.system(*args)
    assert_true $?.success?
    ret
  end
end
