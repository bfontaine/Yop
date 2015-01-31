# -*- coding: UTF-8 -*-

require "yaml"

require_relative "home"

module Yop
  class << self
    def config(key = nil, opts = {})
      read_config unless @conf

      if !key.nil?
        @conf[key]
      else
        unless opts.empty?
          @conf.update(opts)
          save_config
        end
        @conf
      end
    end

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
