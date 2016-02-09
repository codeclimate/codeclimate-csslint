require 'nokogiri'
require 'json'

module CC
  module Engine
    class CSSlint
      autoload :CheckDetails, "cc/engine/csslint/check_details"

      def initialize(directory: , io: , engine_config: )
        @directory = directory
        @engine_config = engine_config
        @io = io
      end

      def run
        Dir.chdir(@directory) do
          results.xpath('//file').each do |file|
            path = file['name'].sub(/\A#{@directory}\//, '')
            file.children.each do |node|
              next unless node.name == "error"
              issue = create_issue(node, path)
              puts("#{issue.to_json}\0")
            end
          end
        end
      end

      private

      def create_issue(node, path)
        check_name = node.attributes.fetch("identifier").value
        check_details = CheckDetails.fetch(check_name)
        
        {
          type: "issue",
          check_name: check_name,
          description: node.attributes.fetch("message").value,
          categories: check_details.categories,
          remediation_points: check_details.remediation_points,
          location: {
            path: path,
            positions: {
              begin: {
                line: node.attributes.fetch("line").value.to_i,
                column: node.attributes.fetch("column").value.to_i
              },
              end: {
                line: node.attributes.fetch("line").value.to_i,
                column: node.attributes.fetch("column").value.to_i
              }
            }
          }
        }
      rescue KeyError => e
        raise MissingAttributesError, "#{e.message} on XML '#{node}' when analyzing file '#{path}'"
      end

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
            include_path if include_path =~ /\.css$/
          end
        end.flatten.compact
      end

      def csslint_xml
        `csslint --format=checkstyle-xml #{files_to_inspect.join(" ")}`
      end

      def files_to_inspect
        if @engine_config["include_paths"]
          build_files_with_inclusions(@engine_config["include_paths"])
        else
          build_files_with_exclusions(@engine_config["exclude_paths"] || [])
        end
      end
    end
    class MissingAttributesError < StandardError
    end
  end
end
