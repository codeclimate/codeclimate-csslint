require "spec_helper"

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

        it 'fails on malformed file' do
          create_source_file('foo.css', '�6�')
          expect{ lint.run }.to output(/Unexpected token/).to_stdout
        end

        it "doesn't analyze *.scss files" do
          create_source_file('foo.scss', id_selector_content)
          expect{ lint.run }.to_not output.to_stdout
        end

        it "only reports issues in the file where they're present" do
          create_source_file('bad.css', id_selector_content)
          create_source_file('good.css', '.foo { margin: 0 }')
          expect{ lint.run }.not_to output(/good\.css/).to_stdout
        end

        describe "with include_paths" do
          let(:engine_config) {
            {"include_paths" => %w(included.css included_dir/ config.yml)}
          }

          before do
            create_source_file("included.css", id_selector_content)
            create_source_file(
              "included_dir/file.css", "p { color: blue !important; }"
            )
            create_source_file(
              "included_dir/sub/sub/subdir/file.css", "img { }"
            )
            create_source_file("config.yml", "foo:\n  bar: \"baz\"")
            create_source_file("not_included.css", "a { outline: none; }")
          end

          it "includes all mentioned files" do
            expect{ lint.run }.to \
              output(/Don't use IDs in selectors./).to_stdout
          end

          it "expands directories" do
            expect{ lint.run }.to output(/Use of !important/).to_stdout
            expect{ lint.run }.to output(/Rule is empty/).to_stdout
          end

          it "excludes any unmentioned files" do
            expect{ lint.run }.not_to \
              output(/Outlines should only be modified using :focus/).to_stdout
          end

          it "shouldn't call a top-level Dir.glob ever" do
            allow(Dir).to receive(:glob).and_call_original
            expect(Dir).not_to receive(:glob).with("**/*.css")
            expect{ lint.run }.to \
              output(/Don't use IDs in selectors./).to_stdout
          end

          it "only includes CSS files, even when a non-CSS file is directly included" do
            expect{ lint.run }.not_to output(/config.yml/).to_stdout
          end
        end

        describe "with custom extensions" do
          let(:engine_config) do
            {
              "config" => {
                "extensions" => %w(.fancycss)
              }
            }
          end

          before do
            create_source_file("master.fancycss", id_selector_content)
          end

          it "takes into account extensions" do
            expect{ lint.run }.to \
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
