require "spec_helper"

class CC::Engine::CSSlint
  describe CheckDetails do
    describe ".fetch" do
      it "returns details for customized checks" do
        details = CheckDetails.fetch("net.csslint.Disallow@import")

        expect(details.categories).to eq ["Bug Risk"]
        expect(details.remediation_points).to eq 50_000
      end

      it "returns defaults for unknown checks" do
        details = CheckDetails.fetch("made-up")

        expect(details.categories).to eq ["Style"]
        expect(details.remediation_points).to eq 50_000
      end
    end
  end
end
