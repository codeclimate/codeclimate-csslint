"use strict";

const checkDetails = require('./check-details');

const DEFAULT_IDENTIFIER = "parse-error";
const forEach = require("csslint/dist/csslint-node").CSSLint.Util.forEach;

function ruleIdentifier(rule) {
  if (!rule || !("id" in rule)) {
    return "generic";
  }
  return rule.id;
};

function reportJSON(filename, report) {
  let check_name = report.rule ? ruleIdentifier(report.rule) : DEFAULT_IDENTIFIER;
  let details = checkDetails(check_name);

  return JSON.stringify({
    type: "issue",
    check_name: check_name,
    description: report.message,
    categories: details.categories,
    remediation_points: details.remediation_points,
    location: {
      path: filename,
      positions: {
        begin: {
          line: report.line || 1,
          column: report.col || 1
        },
        end: {
          line: report.line || 1,
          column: report.col || 1
        }
      }
    }
  }) + "\x00";
}

module.exports = {
  // format information
  id: "codeclimate",
  name: "Code Climate format",

  startFormat: function() {
    return "";
  },
  endFormat: function() {
    return "";
  },

  readError: function(filename, message) {
    let report = {
      type: "error",
      line: 1,
      col: 1,
      message : message
    };
    return reportJSON(filename, report);
  },

  formatResults: function(results, filename/*, options*/) {
    let reports = results.messages;
    let output = [];

    if (reports.length > 0) {
      forEach(reports, function (report) {
        // ignore rollups for now
        if (!report.rollup) {
          output.push(reportJSON(filename, report));
        }
      });
    }

    return output.join("");
  }
};
