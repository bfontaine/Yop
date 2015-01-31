# -*- coding: UTF-8 -*-

require "fileutils"

module Yop
  class << self
    def home(subcomponent = "")
      File.expand_path("~/.yop/#{subcomponent}")
    end

    def init
      FileUtils.mkdir_p home
      FileUtils.mkdir_p home("templates")
      FileUtils.touch home("config.yml")
    end
  end
end
