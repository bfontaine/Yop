# -*- coding: UTF-8 -*-

require "test/unit"
require "yop/version"

class YopVersionTests < Test::Unit::TestCase

  # == #version == #

  def test_version
    assert(Yop.version =~ /^\d+\.\d+\.\d+/)
  end

end
