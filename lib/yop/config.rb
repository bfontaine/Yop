# -*- coding: UTF-8 -*-

require "yaml"

require_relative "home"

module Yop
  class << self
    # Get the local Yop config. If no argument is given the whole config is
    # returned. If one is given, the corresponding value is returned.
    # @param key [Any] the key to lookup
    # @return [Any] either the whole config or the value for `key`
    def config(key = nil)
      read_config unless @conf

      if !key.nil?
        @conf[key]
      else
        @conf
      end
    end

    # Set variables in the local Yop config.
    # @param opts [Hash] an hash which will be merged into the local config
    # @return nil
    def config!(opts = {})
      @conf.update(opts)
      save_config
    end

    # Force-reload the config. This shouldn't be needed unless you know what
    # you're doing (e.g. testing the module).
    def reload!
      read_config
    end

    private

    def read_config
      @conf = YAML.load_file(home("config.yml")) || {}
    end

    def save_config
      File.open(home("config.yml"), "w") do |f|
        f.write YAML.dump(@conf)
      end
    end
  end
end
