# -*- coding: UTF-8 -*-

require_relative "templates"

module Yop
  class << self
    def bootstrap(template, directory)
      init
      get_template(template).apply directory
    end
  end
end
