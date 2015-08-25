require 'cc/engine/csslint'
require 'tmpdir'

module CC
  module Engine
    describe CSSlint do
      let(:code) { Dir.mktmpdir }
      let(:lint) { CSSlint.new(directory: code, io: nil, engine_config: {}) }
      let(:content) { '#id { color: red; }' }

      describe '#run' do
        it 'analyzes *.css files' do
          create_source_file('foo.css', content)
          expect{ lint.run }.to output(/Don't use IDs in selectors./).to_stdout
        end

        it "doesn't analyze *.scss files" do
          create_source_file('foo.scss', content)
          expect{ lint.run }.to_not output.to_stdout
        end

        def create_source_file(path, content)
          File.write(File.join(code, path), content)
        end
      end
    end
  end
end
