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

      def csslint_xml
        exclusions = @engine_config['exclude_paths'] || []
        final_files = files.reject { |f| exclusions.include?(f) }
        `csslint --format=checkstyle-xml #{final_files.join(" ")}`
      end

      def files
        Dir.glob("**/*css")
      end
    end
  end
end
