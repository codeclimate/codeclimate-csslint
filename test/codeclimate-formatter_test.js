const Formatter = require("../lib/codeclimate-formatter");
const expect = require("chai").expect;
const CSSLint = require("csslint/dist/csslint-node").CSSLint;

describe("Code Climate Formatter", function() {
  describe(".startFormat", function() {
    it("returns a blank string", function() {
      expect(Formatter.startFormat()).to.eq("");
    });
  });

  describe(".endFormat", function() {
    it("returns a blank string", function() {
      expect(Formatter.endFormat()).to.eq("");
    });
  });

  describe(".readError", function() {
    it("properly serializes a read error", function() {
      expect(Formatter.readError("foo.css", "Can not read the file")).to.eq(
        '{"type":"issue","check_name":"parse-error","description":"Can not read the file","categories":["Bug Risk"],"remediation_points":50000,"location":{"path":"foo.css","positions":{"begin":{"line":1,"column":1},"end":{"line":1,"column":1}}}}\x00'
      );
    });
  });

  describe(".formatResults", function() {
    it("properly serializes reports", function() {
      let reports = [
        {
          type: "warning",
          line: 1,
          col: 1,
          message: "Don't use adjoining classes.",
          evidence: ".im-bad {",
          rule: CSSLint.getRules().find( rule => rule.id === "adjoining-classes")
        },
        {
          type: "warning",
          line: 10,
          col: 1,
          message: "Disallow empty rules",
          evidence: ".empty {}",
          rule: CSSLint.getRules().find( rule => rule.id === "empty-rules")
        }
      ];

      expect(Formatter.formatResults({messages: reports}, "foo.css")).to.eq(
        '{"type":"issue","check_name":"adjoining-classes","description":"Don\'t use adjoining classes.","categories":["Compatibility"],"remediation_points":50000,"location":{"path":"foo.css","positions":{"begin":{"line":1,"column":1},"end":{"line":1,"column":1}}}}\x00' +
        '{"type":"issue","check_name":"empty-rules","description":"Disallow empty rules","categories":["Bug Risk"],"remediation_points":50000,"location":{"path":"foo.css","positions":{"begin":{"line":10,"column":1},"end":{"line":10,"column":1}}}}\x00'
      );
    });
  });

});
