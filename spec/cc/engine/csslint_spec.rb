require 'cc/engine/csslint'
require 'tmpdir'

module CC
  module Engine
    describe CSSlint do
      let(:code) { Dir.mktmpdir }
      let(:engine_config) { {} }
      let(:lint) do
        CSSlint.new(directory: code, io: nil, engine_config: engine_config)
      end
      let(:id_selector_content) { '#id { color: red; }' }

      describe '#run' do
        it 'analyzes *.css files' do
          create_source_file('foo.css', id_selector_content)
          expect{ lint.run }.to output(/Don't use IDs in selectors./).to_stdout
        end

        it "doesn't analyze *.scss files" do
          create_source_file('foo.scss', id_selector_content)
          expect{ lint.run }.to_not output.to_stdout
        end

        describe "with exclude_paths" do
          let(:engine_config) { {"exclude_paths" => %w(excluded.css)} }

          before do
            create_source_file("not_excluded.css", "p { margin: 5px }")
            create_source_file("excluded.css", id_selector_content)
          end

          it "excludes all matching paths" do
            expect{ lint.run }.not_to \
              output(/Don't use IDs in selectors./).to_stdout
          end
        end
      end

      def create_source_file(path, content)
        abs_path = File.join(code, path)
        FileUtils.mkdir_p(File.dirname(abs_path))
        File.write(abs_path, content)
      end
    end
  end
end
