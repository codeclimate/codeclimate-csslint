require 'nokogiri'
require 'json'

module CC
  module Engine
    class CSSlint
      def initialize(directory: , io: , engine_config: )
        @directory = directory
        @engine_config = engine_config
        @io = io
      end

      def run
        Dir.chdir(@directory) do
          results.xpath('//file').each do |file|
            path = file['name'].sub(/\A#{@directory}\//, '')
            file.xpath('//error').each do |lint|
              issue = {
                type: "issue",
                check_name: lint["source"],
                description: lint["message"],
                categories: ["Style"],
                remediation_points: 500,
                location: {
                  path: path,
                  positions: {
                    begin: {
                      line: lint["line"].to_i,
                      column: lint["column"].to_i
                    },
                    end: {
                      line: lint["line"].to_i,
                      column: lint["column"].to_i
                    }
                  }
                }
              }

              puts("#{issue.to_json}\0")
            end
          end
        end
      end

      private

      def results
        @results ||= Nokogiri::XML(csslint_xml)
      end

      def build_files_with_exclusions(exclusions)
        files = Dir.glob("**/*.css")
        files.reject { |f| exclusions.include?(f) }
      end

      def build_files_with_inclusions(inclusions)
        inclusions.map do |include_path|
          if include_path =~ %r{/$}
            Dir.glob("#{include_path}/**/*.css")
          else
            include_path
          end
        end.flatten
      end

      def csslint_xml
        `csslint --format=checkstyle-xml #{files_to_inspect.join(" ")}`
      end

      def files_to_inspect
        if includes = @engine_config["include_paths"]
          build_files_with_inclusions(includes)
        else
          build_files_with_exclusions(@engine_config["exclude_paths"] || [])
        end
      end
    end
  end
end
