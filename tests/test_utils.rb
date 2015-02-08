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
  end

  def teardown
    Yop.basepath = @old_basepath
    FileUtils.rm_rf @basepath

    $stdin = @_stdin
    $stdout = @_stdout
    $stderr = @_stderr
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

  # ls -ar
  def ls_ar path
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
end
