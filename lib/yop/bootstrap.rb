# -*- coding: UTF-8 -*-

require_relative "templates"

module Yop
  class << self
    # Bootstrap a project (which will be) located in `directory` with the
    # template `template`
    # @param template [String] the template name
    # @param directory [String] the directory path
    # @return nil
    def bootstrap(template, directory)
      get_template(template).apply directory
    end
  end
end
