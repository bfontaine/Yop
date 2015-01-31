# -*- coding: UTF-8 -*-

require "fileutils"

require_relative "home"
require_relative "config"
require_relative "exceptions"

module Yop
  class Template
    extend FileUtils::Verbose

    def initialize(base_directory, vars = {})
      @base = base_directory
      @vars = vars
    end

    def skip?(path)
      [/^\.git$/, /.+~$/, /^\..+\.sw.$/].any? do |reg|
        path =~ reg
      end
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
      sources = cd(@base) { Dir["**/*", "**/.*"] }

      cd directory do
        sources.each do |path|
          next unless skip? path

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
      fail NonExistentTemplate(name) if dirs.empty
      Template.new(dirs.first, config(:vars) || {})
    end
  end
end
