# -*- coding: UTF-8 -*-

require "fileutils"
require "tmpdir"
require "yop"

class Test::Unit::TestCase
  def set_temporary_home
    @old_basepath = Yop.basepath
    @basepath = Yop.basepath = "#{Dir.mktmpdir}/.yop"
  end

  def unset_temporary_home
    Yop.basepath = @old_basepath
    FileUtils.rm_rf @basepath
  end

  # proxy FileUtils methods by prepending a @basepath
  [:mkdir, :mkdir_p, :touch].each do |name|
    define_method(name) do |path|
      FileUtils.send(name, "#{@basepath}/#{path}")
    end
  end
end
