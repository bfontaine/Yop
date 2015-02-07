# -*- coding: UTF-8 -*-

require "fileutils"

require_relative "home"
require_relative "config"
require_relative "exceptions"

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

    # Create a new template from a base directory
    # @param base_directory [String] a path to an existing directory which will
    #                                be used as a source when this template
    #                                will be applied
    # @param vars [Hash]
    def initialize(base_directory, vars = {})
      @base = base_directory
      @vars = vars
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

          if File.directory? source
            mkdir_p path
          elsif File.file? source
            File.open(path, "w") do |f|
              content = replace_vars source
              f.write(content)
            end
          else
            puts "Warning: unsupported file: #{source}"
            next
          end
          mirror_perms source, path
        end
      end
    end

    private

    def ignore_extension?(path)
      %w[swp swo pyc class].any? { |e| path.end_with?(".#{e}") }
    end

    def skip?(path)
      ignore_extension?(path) ||
        [/\.git/, /.~$/, /__pycache__/].any? { |reg| path =~ reg }
    end

    def replace_vars(source)
      # TODO
      File.read(source)
    end

    def mirror_perms(source, target)
      mode = File.new(source).stat.mode
      File.chmod(mode, target)
    end
  end
end
