const checkDetails = require("../lib/check-details");
const expect = require("chai").expect;

describe("Check Details", function() {
  it("returns details for customized checks", function() {
    let details = checkDetails("import");

    expect(details.categories).to.deep.equal(["Performance"]);
    expect(details.remediation_points).to.eq(50000);
  });

  it("returns defauls for unknown checks", function() {
    let details = checkDetails("made-up");

    expect(details.categories).to.deep.equal(["Style"]);
    expect(details.remediation_points).to.eq(50000);
  });
});
