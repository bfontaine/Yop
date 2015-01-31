# -*- coding: UTF-8 -*-

require_relative "templates"

module Yop
  class << self
    def bootstrap(template, directory)
      get_template(template).apply directory
    end
  end
end
