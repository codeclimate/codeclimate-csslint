require "json"
require "nokogiri"
require "ostruct"
require "shellwords"

module CC
  module Engine
    MissingAttributesError = Class.new(StandardError)

    DEFAULT_IDENTIFIER = OpenStruct.new(value: "parse-error")

    class CSSlint
      DEFAULT_EXTENSIONS = [".css"].freeze

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

      attr_reader :engine_config

      # rubocop:disable Metrics/MethodLength
      def create_issue(node, path)
        check_name = node.attributes.fetch("identifier", DEFAULT_IDENTIFIER).value
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
      rescue KeyError => ex
        raise MissingAttributesError, "#{ex.message} on XML '#{node}' when analyzing file '#{path}'"
      end
      # rubocop:enable Metrics/MethodLength

      def results
        @results ||= Nokogiri::XML(csslint_xml)
      end

      def csslint_xml
        `csslint --format=checkstyle-xml #{files_to_inspect.shelljoin}`
      end

      def files_to_inspect
        include_paths = engine_config.fetch("include_paths", ["./"])
        extensions = engine_config.fetch("extensions", DEFAULT_EXTENSIONS)
        extensions_glob = extensions.join(",")
        include_paths.flat_map do |path|
          if path.end_with?("/")
            Dir.glob("#{File.expand_path path}/**/*{#{extensions_glob}}")
          elsif path.end_with?(*extensions)
            path
          end
        end.compact
      end
    end
  end
end
