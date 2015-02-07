# -*- coding: UTF-8 -*-

require "fileutils"

module Yop
  # The base path used for all files
  @basepath = "~/.yop"

  class << self
    # let applications change the base path
    attr_accessor :basepath

    # Return the local Yop directory location. If an argument is given, it
    # assumes it's a Yop subcomponent and returns its location.
    # @param subcomponent [String] the subcomponent to look for
    # @return [String] the path to the local Yop directory or its subcomponent
    def home(subcomponent = "")
      File.expand_path("#{@basepath}/#{subcomponent}")
    end

    # Initialize Yop's local directory
    # @return nil
    def init
      FileUtils.mkdir_p home
      FileUtils.mkdir_p home("templates")
      FileUtils.touch home("config.yml")
    end
  end
end
