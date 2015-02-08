# -*- coding: UTF-8 -*-

require_relative "exceptions"

module Yop
  class UI
    # get a variable's value
    # @param name [String] the variable's name
    def get_var(name)
      fail UndefinedTemplateVariable, name
    end
  end

  class TerminalUI < UI
    def get_var(name)
      print "#{name} = "
      $stdin.readline.chomp
    rescue EOFError
      super
    end
  end
end
