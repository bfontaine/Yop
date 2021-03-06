# -*- coding: UTF-8 -*-

require "fileutils"

require_relative "home"
require_relative "config"
require_relative "exceptions"
require_relative "ui"
require_relative "extend/file"

module Yop
  class << self
    # @return [Array] all the available templates
    def templates
      Dir["#{Yop.home("templates")}/*"]
    end

    # Retrieve a template from its name, or raise a `NonExistentTemplate`
    # exception if it doesn't exist
    # @param name [String] the template name
    # @return [Yop::Template]
    def get_template(name)
      dirs = Dir["#{Yop.home("templates")}/#{name}"]
      fail NonExistentTemplate, name if dirs.empty?
      Template.new(dirs.first, config(:vars) || {})
    end
  end

  # A Yop Template, which consists of a base directory and an hash of variables
  class Template
    include FileUtils

    # The UI used to get unknown variables
    # @param value [Yop::UI]
    # @return [Yop::UI]
    attr_writer :ui

    # The prefix used for dynamic variables
    DYNAMIC_PREFIX = Regexp.escape "!"

    # Create a new template from a base directory
    # @param base_directory [String] a path to an existing directory which will
    #        be used as a source when this template will be applied
    # @param vars [Hash] variables to use in this template. If a variable is
    #        found in the template but isn't in the hash it'll be retrieved
    #        from the template's ui (default is Yop::TerminalUI).
    # @param config [Hash] additional configuration options
    def initialize(base_directory, vars = {}, config = {})
      @base = base_directory
      @vars = vars
      @config = config

      compile_var_pattern!
    end

    # Apply the template on a directory. It creates it if it doesn't exist,
    # then recursively copies itself in it
    # @param directory [String] the directory in which to copy
    # @return nil
    def apply(directory)
      mkdir_p directory

      # get relative paths
      sources = []
      cd(@base) { sources = Dir["**/*", "**/.*"] }

      cd directory do
        sources.each do |path|
          next if skip? path

          source = "#{@base}/#{path}"
          path = replace_vars_in_path path

          if File.symlink?(source) || File.binary?(source)
            copy_entry source, path
          elsif File.directory? source
            mkdir_p path
          elsif File.file? source
            File.open(path, "w") do |f|
              content = replace_vars source
              f.write(content)
            end
          else
            fail UnsupportedFileType, source
          end
          mirror_perms source, path
        end
      end
    end

    # Shortcut to add a template variable
    # @param name [Any] the variable's name
    # @param value [Any] the variable's value
    # @return [Any] the provided value
    def []=(name, value)
      @vars[name.to_s] = value
    end

    private

    # @param path [String]
    def ignore_extension?(path)
      %w[swp swo pyc class].any? { |e| path.end_with?(".#{e}") }
    end

    # @param path [String]
    def skip?(path)
      ignore_extension?(path) ||
        [/^\.git$/, /.~$/, /__pycache__/].any? { |reg| path =~ reg }
    end

    def dynamic_var?(name)
      name && name =~ /^#{DYNAMIC_PREFIX}/
    end

    # Replace vars in a file
    # @param source [String] the file path
    def replace_vars(source)
      replace_vars_in_string File.read(source)
    end

    # Replace vars in a string
    # @param text [String]
    def replace_vars_in_string(text)
      text.gsub(@var_pattern) do
        name = Regexp.last_match[1]

        if dynamic_var? name
          get_dynamic_var name
        else
          @vars[name] || @vars[name.to_sym] || get_var(name)
        end
      end
    end

    # Same as +replace_vars_in_string+ but might be modified in the future to
    # perform some specific path checks.
    # @param source [String]
    # @return [String]
    alias_method :replace_vars_in_path, :replace_vars_in_string

    # @param name [String]
    def get_var(name)
      @vars[name] = (@ui ||= Yop::TerminalUI.new).get_var(name)
    end

    # Return a value for a dynamic variable.
    # @param name [String]
    def get_dynamic_var(name)
      case name[DYNAMIC_PREFIX.size..-1]
      # {(!CURRENT_YEAR)} -> the current year (four digits)
      when "CURRENT_YEAR"
        Time.now.year.to_s
      else
        fail UndefinedDynamicTemplateVariable, name
      end
    end

    # Initialize @var_pattern
    def compile_var_pattern!
      opening = Regexp.escape(@config[:before_var] || "{(")
      closing = Regexp.escape(@config[:after_var] || ")}")

      @var_pattern = /#{opening}(#{DYNAMIC_PREFIX}?[_A-Z][_A-Z0-9]*)#{closing}/
    end

    # Try to mirror the permissions from a file to another
    # @param source [String]
    # @param target [String]
    # @return [Boolean] +true+ if the permissions were successfully mirrored
    def mirror_perms(source, target)
      return mirror_perms_symlink(source, target) if File.symlink? source
      mode = File.new(source).stat.mode
      File.chmod(mode, target)
      true
    end

    # Try to mirror the permissions from a symlink to another. Use
    # +mirror_perms+ if you're not sure if +source+ is a symlink.
    # @param source [String]
    # @param target [String]
    # @return [Boolean] +true+ if the permissions were successfully mirrored
    def mirror_perms_symlink(source, target)
      mode = File.new(source).lstat.mode
      File.lchmod(mode, target)
      true
    rescue NotImplementedError
      false
    end
  end
end
