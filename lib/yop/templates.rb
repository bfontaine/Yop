# -*- coding: UTF-8 -*-

require "fileutils"

require_relative "home"
require_relative "config"
require_relative "exceptions"

module Yop
  class Template
    include FileUtils

    def initialize(base_directory, vars = {})
      @base = base_directory
      @vars = vars
    end

    def ignore_extension?(path)
      %w[.swp .swo .pyc .class].any? { |e| path.end_with?(e) }
    end

    def skip?(path)
      return true if ignore_extension? path

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
  end

  class << self
    # @return [Array] all the available templates
    def templates
      Dir["#{Yop.home("templates")}/*"]
    end

    def get_template(name)
      dirs = Dir["#{Yop.home("templates")}/#{name}"]
      fail NonExistentTemplate, name if dirs.empty?
      Template.new(dirs.first, config(:vars) || {})
    end
  end
end
