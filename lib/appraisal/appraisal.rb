require 'appraisal/gemfile'
require 'appraisal/command'
require 'fileutils'

module Appraisal
  # Represents one appraisal and its dependencies
  class Appraisal
    attr_reader :name, :gemfile

    def initialize(name, source_gemfile)
      @name = name
      @gemfile = source_gemfile.dup
    end

    def gem(name, *requirements)
      gemfile.gem(name, *requirements)
    end

    def write_gemfile
      ::File.open(gemfile_path, "w") do |file|
        file.puts("# This file was generated by Appraisal")
        file.puts
        file.write(gemfile.to_s)
      end
    end

    def install
      Command.new("bundle install --gemfile=#{gemfile_path}").run
    end

    def gemfile_path
      unless ::File.exist?(gemfile_root)
        FileUtils.mkdir(gemfile_root)
      end

      ::File.join(gemfile_root, "#{name}.gemfile")
    end

    private

    def gemfile_root
      "gemfiles"
    end
  end
end

