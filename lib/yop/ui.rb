# -*- coding: UTF-8 -*-

require_relative "exceptions"

module Yop
  # A base UI class
  class UI
    # get a variable's value. It'll fail with +UndefinedTemplateVariable+ if
    # the variable can't be found.
    # @param name [String] the variable's name
    # @return [Any]
    def get_var(name)
      fail UndefinedTemplateVariable, name
    end
  end

  # A terminal UI
  class TerminalUI < UI
    # Get a variable's value from the terminal
    def get_var(name)
      print "#{name} = "
      $stdin.readline.chomp
    rescue EOFError
      super
    end
  end
end
