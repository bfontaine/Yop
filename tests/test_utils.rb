# -*- coding: UTF-8 -*-

require "fileutils"
require "tmpdir"
require "yop"

class YopTestCase < Test::Unit::TestCase
  def setup
    @old_basepath = Yop.basepath
    @basepath = Yop.basepath = "#{Dir.mktmpdir}/.yop"
  end

  def teardown
    Yop.basepath = @old_basepath
    FileUtils.rm_rf @basepath
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
